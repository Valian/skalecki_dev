%{
  title: "Why I Switched to Elixir After 10 Years of C++",
  description: "The cognitive load of manual memory management vs the freedom of the actor model. A deep dive into developer happiness and system resiliency.",
  tags: ["elixir", "programming", "career"]
}
---

After a decade of wrestling with C++, I found myself asking a dangerous question: *Is this really the best we can do?*

## The Weight of Manual Memory Management

Every C++ developer knows the feeling. That creeping anxiety when you're not quite sure if you've freed that pointer. The hours spent debugging a segfault that only appears in production. The mental overhead of keeping track of ownership semantics.

Don't get me wrong—C++ is a powerful language. It lets you do things that would be impossible elsewhere. But at what cost?

## Enter Elixir

My first encounter with Elixir was accidental. A colleague recommended it for a side project, and I was skeptical. Functional programming? Pattern matching? No mutable state?

But then I wrote my first GenServer. And something clicked.

```elixir
defmodule Counter do
  use GenServer

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def increment do
    GenServer.cast(__MODULE__, :increment)
  end

  def get_value do
    GenServer.call(__MODULE__, :get)
  end

  @impl true
  def init(initial_value), do: {:ok, initial_value}

  @impl true
  def handle_cast(:increment, state), do: {:noreply, state + 1}

  @impl true
  def handle_call(:get, _from, state), do: {:reply, state, state}
end
```

No locks. No mutexes. No race conditions. Just pure, beautiful message passing.

## The Actor Model Changes Everything

The BEAM virtual machine treats processes as first-class citizens. Each process has its own heap, its own garbage collector, and communicates with others through message passing.

This isn't just a programming paradigm—it's a philosophy. Instead of thinking about shared state and synchronization, you think about independent actors and their interactions.

## Developer Happiness Matters

Here's what surprised me most: I actually *enjoy* writing Elixir. The pattern matching makes complex data transformations readable. The pipe operator makes code flow naturally. The documentation is exceptional.

After ten years of C++, I'd forgotten what it felt like to be excited about code.

## Would I Go Back?

For certain problems—game engines, operating systems, embedded systems—C++ is still the right choice. But for building web applications, APIs, and distributed systems? Elixir has fundamentally changed how I think about software.

The cognitive load is just... less. And that matters more than I ever realized.
