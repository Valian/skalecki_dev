%{
  title: "The Art of Pushing Back",
  description: "Why saying \"no\" to a feature request is often the most senior engineering decision you can make. Balancing technical debt with business velocity.",
  tags: ["engineering", "career", "leadership"]
}
---

Early in my career, I thought being a good engineer meant saying "yes" to everything. Stakeholder wants a feature? I'll build it. PM has an idea? Let me add it to the sprint.

I was wrong.

## The Hidden Cost of Yes

Every feature you build has costs beyond the initial development:

- **Maintenance burden**: Someone has to fix bugs, update dependencies, handle edge cases
- **Cognitive load**: Every feature increases the complexity developers must hold in their heads
- **Opportunity cost**: Time spent on Feature A is time not spent on Feature B
- **Testing surface**: More features means more tests, more CI time, more potential for flaky tests

The senior engineers I admire most are the ones who push back thoughtfully.

## How to Push Back (Without Being a Jerk)

Pushing back doesn't mean being difficult. It means being a partner in decision-making.

### 1. Understand the Real Problem

Before saying no, make sure you understand what problem the stakeholder is trying to solve. Often, there's a simpler solution hiding behind a complex feature request.

> "Help me understand—what's the outcome you're looking for? There might be a faster way to get there."

### 2. Quantify the Cost

Stakeholders often don't realize the true cost of features. Be specific:

- "This feature will take about 2 sprints to build properly"
- "It will add ~500 lines of code that we'll need to maintain indefinitely"
- "We'll need to add 3 new database tables and handle migrations"

### 3. Propose Alternatives

Never just say "no." Always offer alternatives:

- "What if we did X instead? It solves 80% of the problem with 20% of the effort."
- "We could ship a simpler version first and iterate based on user feedback."
- "This is a great idea for Q2 when we've paid down some tech debt."

### 4. Know When to Commit

Sometimes the business genuinely needs the feature, complexity and all. Once you've made your case and a decision is made, commit fully. Don't be the person who says "I told you so" when things get difficult.

## Real Example: The Dashboard That Wasn't

Last year, a stakeholder wanted a comprehensive analytics dashboard. Real-time updates, custom date ranges, exportable reports—the works.

My initial estimate: 6 weeks.

Instead of building it, I asked: "What decisions will this dashboard help you make?"

Turns out, they really just needed to answer three specific questions about user engagement. We built a simple page with three charts in 3 days.

Six months later, they still haven't needed anything more complex.

## The Senior Engineer's Job

Your job isn't to build what people ask for. It's to solve problems effectively. Sometimes that means building exactly what's requested. Often, it means finding a simpler path.

The most valuable thing you can say is often: "Let's talk about what problem we're really solving here."

That's not being difficult. That's being senior.
