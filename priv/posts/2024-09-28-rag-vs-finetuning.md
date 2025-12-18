%{
  title: "Pragmatic AI: When to use RAG vs Fine-tuning",
  description: "Lessons learned from building 3 production AI assistants. Why context windows are often enough, and when you actually need to train weights.",
  tags: ["ai", "llm", "engineering"]
}
---

After shipping three production AI assistants in the past year, I've developed some strong opinions about when to use RAG (Retrieval-Augmented Generation) versus fine-tuning. Spoiler: RAG wins more often than you'd think.

## The Default Should Be RAG

Here's my hot take: **start with RAG, and only fine-tune when you have a specific, measurable reason**.

Why? Because RAG gives you:

- **Instant updates**: Change your knowledge base, and the model's responses change immediately
- **Transparency**: You can see exactly what context was retrieved
- **Cost efficiency**: No expensive training runs
- **Flexibility**: Swap out the base model anytime

## When RAG Shines

RAG is perfect when your problem involves:

1. **Factual knowledge retrieval**: Q&A systems, documentation assistants, support bots
2. **Frequently changing information**: Product catalogs, news, policies
3. **Domain-specific knowledge**: Company procedures, technical documentation
4. **Attribution requirements**: When you need to cite sources

```python
# Simple RAG with semantic search
def answer_question(question: str, knowledge_base: VectorStore) -> str:
    relevant_chunks = knowledge_base.similarity_search(question, k=5)
    context = "\n".join(chunk.content for chunk in relevant_chunks)

    return llm.complete(
        f"Context: {context}\n\nQuestion: {question}\n\nAnswer:"
    )
```

## When Fine-tuning Makes Sense

Fine-tuning is the right choice when you need to:

1. **Change the model's behavior or style**: Making it more concise, formal, or domain-specific
2. **Teach new skills**: Structured output formats, code generation in specific frameworks
3. **Reduce latency**: Embedding knowledge directly means no retrieval step
4. **Handle edge cases**: When RAG consistently fails on certain query types

## The Hybrid Approach

In practice, the best systems often combine both:

- **Fine-tuned base model** for style, tone, and domain understanding
- **RAG layer** for specific factual knowledge and up-to-date information

This gives you the best of both worlds: a model that "speaks your language" while having access to current information.

## Practical Decision Framework

Before deciding, ask yourself:

1. **How often does the knowledge change?** → Frequently? Use RAG.
2. **Do you need to change HOW the model responds?** → Yes? Consider fine-tuning.
3. **What's your budget for training?** → Limited? Start with RAG.
4. **How important is interpretability?** → Very? RAG provides better visibility.

## My Real-World Experience

For our customer support assistant at [researchmate.ai](https://researchmate.ai), we started with pure RAG over our documentation. It worked well for 80% of queries.

For the remaining 20%—queries that required understanding research methodology concepts—we fine-tuned a smaller model on examples of good responses. The combination handles 95%+ of queries correctly.

The key insight: **don't over-engineer from the start**. RAG is quick to implement, easy to iterate on, and often good enough. Save fine-tuning for when you have clear evidence it's needed.
