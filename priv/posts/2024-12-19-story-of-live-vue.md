%{
  title: "The Story of LiveVue",
  description: "How and why I built LiveVue - a library that bridges Phoenix LiveView and Vue.js, bringing the best of both worlds together.",
  tags: ["elixir", "phoenix", "vue", "live_vue", "open-source"]
}
---

Today live_vue hit 1.0! To celebrate, I'm going to tell the story of how it all started.

First public commit of LiveVue happened on May 8, 2024. Looking back, it's quite a long time ago.

points to cover
- reasons to create, inspiration by live_svelte, missing Vue DX, no good option for client-side declarative rendering in Phoenix
- how it works under the hood - Hook, props, handlers (for reusable components, `v-on:event={JS.toggle("#element")})`). Handlers turned out not that useful, from my experience they always looked like `v-on:event={JS.push_event("event")}` but they're still in the library.
- started by forking live_svelte and tweaking to "make it work"
- removal of esbuild, replaced by vite for SSR and better DX. Esbuilt required two separate processes, one to build SSR bundle and one to build client-side bundle. Vite was able to do it all in memory, with instant reload of both SSR bundle and client-side .bundle. This, together with a small change in Phoenix config, gave a stateful hot reload across the whole stack! It required some tweaks, but they're embedded in the vite plugin provided by live_vue
- design of the .vue component API


Then, a vision emerged - I wanted to create 1-to-1 replacement for HEEX without giving up on LiveView features. Vue sigil helps but it was not enough for big components. Instead, I went for proven patterns - Intertia.js approach of a single-component per view, and colocating in lib.

Improvements over time:
- lazy loading of components with preloads. (todo - explain how it works, basically invoking SSR gives us information which JS files are required, so we could embed prefetch code in the initial HTML)
- colocation of components - since I wanted to have one live_vue component per live view, it made sense to keep them close. In my project (postline.ai)[https://postline.ai] I'm not using HEEX at all, page layout is rendered via Vue.

(TODO - insert screenshot from my current approach).


After that, project started growing. I wanted more composables, and better performance by default! So I've done migration to Typescript in 0.5.0, and started working on performance improvements. It was a journey deep into LiveView internals.



To make my vision reality, I wanted to send a really minimal diff to the client. First step, was to send only changed html attributes. Since vue component gathers all props into a single attribute, I had to manually construct `__changed__` map for each attr.

(insert example from live_vue repo)

That was a big improvement - Phoenix was not sending any data to the client for unchanged attributes.

Around that time, I was already using live_vue in production, and being fairly vocal on X about it. I decided to give a talk on ElixirConfEU 2025 titled `Why mixing LiveView and a frontend library is a great idea`, which went pretty good! Sadly recording is not yet published to youtube, but here are my [slides](https://elixirconf.skalecki.dev/slides/1). I've spent wonderful time talking to other Elixir developers, and was able to meet my personal heroes like Jose Valim, Chris McCord, Zach Daniels, Lars Wikman, Benjamin Milde (LostKobrakai), Hugo Baraúna and many others <3

Back to the story! there was still an obvious performance problem. Even if a single prop was updated, entire props object was retransferred. Far from ideal.

So, I wanted to use something like `json_diff`. Live_svelte has support for LiveJson, but it's very explicit. I was curious if I will be able to make it enabled by default for every assign change.

TO achieve this, I needed to have a "before" and "after" state to compute the diff. It turns out, `assigns.__changed__` stores previous versions of map assigns, but not arrays. Thankfully, [my PR](https://github.com/phoenixframework/phoenix_live_view/pull/3392) was accepted and I was able to continue my research.

Next up, I needed to construct an actual diff. I decided to use JSON patch [RFC 6902](https://datatracker.ietf.org/doc/html/rfc6902). There's a great library in Elixir called [jsonpatch](https://github.com/corka149/jsonpatch) doing just this. To make it working, I had to first implement a custom protocol LiveVue.Encoder for turning structs into Json. It serves the same role as Jason.Encoder, but instead of giving back strings it turned structs into plain maps that could be diffed. Next, I've implemented a first version constructing these diffs and then consuming on the client side. It worked! In some cases, payload sizes went down 90+%!

Example of a diff:
```
TODO
```

But still, there was a big issue: diffing lists. Why? Here's an example:

```
original = [
  %{id: 1, name: "test1"},
  %{id: 2, name: "test2"},
  %{id: 3, name: "test3"},
  %{id: 4, name: "test4"},
  %{id: 5, name: "test5"},
  %{id: 6, name: "test6"},
]

updated = List.insert_at(original, 0, %{id: 123, name: "test123"})

Jsonpatch.diff(original, updated)

```

Output:

```
[
  %{value: %{id: 6, name: "test6"}, path: "/6", op: "add"},
  %{value: "test5", path: "/5/name", op: "replace"},
  %{value: 5, path: "/5/id", op: "replace"},
  %{value: "test4", path: "/4/name", op: "replace"},
  %{value: 4, path: "/4/id", op: "replace"},
  %{value: "test3", path: "/3/name", op: "replace"},
  %{value: 3, path: "/3/id", op: "replace"},
  %{value: "test2", path: "/2/name", op: "replace"},
  %{value: 2, path: "/2/id", op: "replace"},
  %{value: "test1", path: "/1/name", op: "replace"},
  %{value: 1, path: "/1/id", op: "replace"},
  %{value: "test123", path: "/0/name", op: "replace"},
  %{value: 123, path: "/0/id", op: "replace"}
]
```

It was happening because diff was made pairwise. Should we live with it? Of course not!

I made an assumption we want to match items by `:id` key - in Phoenix LiveView, this is a safe default, since often we're using some kind of persistency with Ids (ecto).

If I could do it, then we could really send minimal diffs! Could I figure it out? Heck yes!

(TODO: insert meme we did it not because it was easy, but because we thought it will be easy)

So I went on a mission. First, I refactored jsonpatch library to generally improve performance of diffing. In my tests I was able to improve performance by factor of 10, even without diffing by ID.

But then, diffing by ID turned out to be extremely hard. Why? Mostly because of "moves". If item is moved within array, then all future keys of jsondiff should be shifted. I've spent way too much time on this but finally submitted a [patch](https://github.com/corka149/jsonpatch/pull/32) that treats moves as removal and insertion. In real cases, moves are rare, so it's a good compromise.

That allowed to no only send minimal diffs for insertions / removals, but also diffing updates within lists. Since we could prune unnecessary comparisions, overall performance of the diffing process went up 2-3x for typical usage. Example:

(TODO - add example )

So, goal achieved and released in 0.6.0, togeter with first composables:

- useLiveNavigation() for programatic live patches (TODO - insert short example)
- useLiveEvent() to easily listen for sever-sent events with `push_event` (example)
- Link component in Vue

That version also brought a big documentation overhaul. Previously, everything was in README. With help of Claude code I was able to quickly convert it into well-structured guides.


As I was expanding on client utilities I knew it's time to invest into proper testing setup. So I've created a JS test suite, and E2E test suite with Playwright. Setting it up was not trivial, but again LLMs helped a lot by adjusting Phoenix LiveView E2E suite to fit my project.

I was also wokring on covering remaining features of LiveView that were not yet supported by LiveVue. Release 0.7.0 brought `useLiveUpload`, a handy wrapper around phoenix js code making it extremely easy to use live file uploads.

(TOOD - add example of useLiveUpload)

Then, after 0.7.3 release, LiveView 1.8.0 came out. And it changed things! Tailwind v4, bulma, colocated hooks. I had to rewrite installation instructions so people could keep using my library.

Then, I stumbled upon `PhoenixVite` from universally loved `LostKobrakai`. It was an igniter installed to replace esbuild by vite. Perfect opportunity to build upon. I knew installation was a big adoption barrier, since it had 11 steps. Creating a good ingiter installer would completly remove that obstacle. It took some time and iterations, but it's possible to install live vue by typing `mix igniter.install live_vue`!

I wanted to finally reach my goal and have complete coverage of LiveView features. I still missed two big things: forms and streams.

Thanks to my work on json diffing, streams were quite easy to do. I just had to add two custom diff operations, `limit` and `upsert`, learn how streams store items under the hood, and create a translation of streams into props. Since I owned both backend encoding and frontend decoding I could translate streams directly to array props. Personally I'm really proud of how it turned out.

```
TODO - add example
```

Next, forms. It's a huge reason why we love LiveVue so much - there's no need to duplicate validation code on the frontend. How we could solve this in Vue? of course, composables!

In the past I've used library `VeeValidate` and it was a joy to use. So I decided to build my own version, tailor-made for live_vue.

First, I went a rabbit hole of Phoenix.Form implementation. Turns out it's not so easy to convert a (possibly nested) form into a JSON with values and errors - I had to understand which fields are embedded, if they're `:single` or `:multi`, and process them accordingly. But it's ready, you can check the implementation [here](https://github.com/Valian/live_vue/blob/e52b08267b649a7c0ad83fb15d56510b5ddfc1da/lib/live_vue/encoder.ex#L123)


Next, I had to write a client-side implementation. I decided for an easy, TypeScript-enabled API.

(TODO - example)

Implementation was... tricky. Handling asynchronous updates from server side, keeping track of `isTouched` and `initialValue`, dynamically preparing computed fields like `errorMessage`, or `isValid`, caching created fields, ensuring not to lose reactivty, preparing a full TS coverage (it's hands-off the [craziest TypeScript code](https://github.com/Valian/live_vue/blob/e52b08267b649a7c0ad83fb15d56510b5ddfc1da/assets/useLiveForm.ts#L60) I've ever written!). Then, providing utilities to quickly bind all required attributes and handlers to inputs, providing nice API for arrays, writing E2E tests. I've spent a really long time working on that feature but in the end I think it was worth it.

Last big change of 1.0 release was creating VS code extension for ~VUE sigil highlighting. I've tried all LLMs to add support for autocomplete, TS checks etc but it turns out it's really hard! So for now syntax highlighting has to be enough. If you're up for a challenge, please let me know!

So, here we are. Version 1.0 was released *today*, after 1.5 years of development.

It's a stable, used in production library that let's you replace HEEX by Vue without losing any LiveView features. It can be used either to "sprinkle" Vue here and there, or to completely replace HEEX with Vue. In my humble opinion, tight integration with LiveView make it a better choice than Inertia.js for Phoenix developers.


Plans for the future?
- Try to backport some of these features to live_svelte and live_react
- Improve VS code extension

Want to try it now?

```bash
mix igniter.new live_vue_website --with phx.new --with-args "--database sqlite3" --install live_vue
```

have a Happy New Year! 🎉

---

*LiveVue is available on [Hex.pm](https://hex.pm/packages/live_vue) and [GitHub](https://github.com/Valian/live_vue). Documentation at [hexdocs.pm/live_vue](https://hexdocs.pm/live_vue).*
