---
layout: post
title: Five AI Terms Everyone Should Understand
subtitle: Tokens, context windows, temperature, hallucination, and RAG in plain language
cover-img: /assets/img/rag-cover.jpg
thumbnail-img: /assets/img/rag-cover.jpg
share-img: /assets/img/rag-cover.jpg
tags: [ai, llm, rag, machine-learning, beginners]
author: kieetnvt
---

People talk about AI constantly, but many conversations still get fuzzy once terms like tokens, context windows, hallucination, or RAG show up.

You do not need to become a machine learning researcher to use AI well. But if you understand a few core ideas, you can write better prompts, evaluate AI tools more clearly, and avoid trusting the model in the wrong places.

Here are five AI terms worth knowing properly.

## 1. Tokens

AI language models do not read text the same way humans do. They process **tokens**.

A token is a small chunk of text. Sometimes it is a full word. Sometimes it is part of a word. Sometimes it is punctuation or whitespace. For example, a sentence like:

> I love pizza

might be represented as a few tokens such as `I`, ` love`, and ` pizza`.

The exact split depends on the tokenizer used by the model, but the practical idea is simple: tokens are the pieces of text the model receives, reasons over, and generates.

Why does this matter?

Because AI systems count tokens behind the scenes. Your prompt uses tokens. The conversation history uses tokens. Uploaded documents use tokens. The model's answer uses tokens too.

That affects three things:

- **Cost:** API pricing is often based on input and output tokens.
- **Speed:** More tokens usually mean more work for the model.
- **Memory:** A model can only consider a limited number of tokens at once.

Once you understand tokens, a lot of AI behavior makes more sense. Long prompts are not just "long text." They are more pieces for the model to process. Long conversations are not endless memory. They are token budgets being filled.

## 2. Context Window

A **context window** is the amount of text a model can consider at one time, measured in tokens.

Think of it like a whiteboard. Everything the model can currently see must fit on that board:

- system instructions
- your prompt
- previous messages
- pasted text
- retrieved documents
- the model's own earlier replies

When the board is small, the model can only work with a limited amount of information. When the board is large, it can consider longer conversations and bigger documents.

This is why an AI assistant can appear to forget earlier parts of a conversation. It may not be ignoring you. The earlier content may simply no longer fit into the active context, or the application may have summarized or dropped part of it.

Large context windows are useful, but they are not magic. More context can also mean more irrelevant information for the model to sort through. If you paste a huge document and ask a vague question, the model still has to decide what matters.

The practical lesson: when using AI for important work, keep the relevant information close to the question. Do not assume the model remembers every detail from a long chat.

## 3. Temperature

**Temperature** controls how predictable or varied a model's output should be.

At a low temperature, the model tends to choose safer, more likely next tokens. The result is usually more consistent and less surprising.

At a higher temperature, the model is allowed to take more chances. The output may become more creative, more varied, and sometimes less reliable.

For example, if you ask a model to complete:

> The cat sat on the...

At a low temperature, it might choose something obvious like `mat` or `floor`.

At a higher temperature, it might choose something unusual, poetic, or strange.

Neither setting is universally better. It depends on the task.

Use lower temperature for work where consistency matters:

- summarizing documents
- extracting structured information
- writing code
- answering factual questions
- following a strict format

Use higher temperature when variation is useful:

- brainstorming
- fiction
- naming ideas
- marketing copy
- exploring alternative phrasings

Many consumer AI apps do not expose temperature directly, but developer tools and APIs often do. If you ever see that setting, think of it as a control for how much randomness you want in the answer.

## 4. Hallucination

**Hallucination** is when an AI model produces an answer that sounds confident but is wrong.

The dangerous part is not just that the model can make mistakes. Every tool can make mistakes. The dangerous part is that a model can present a made-up answer with the same tone it uses for a correct one.

For example, you might ask about a book, a court case, a library function, or a historical event. If the model does not actually have the answer, it may still generate something that looks plausible: a title, an author, a year, a citation, or an API that does not exist.

This happens because language models are not databases. They generate likely text based on patterns learned during training and the context provided at runtime. They do not automatically verify facts unless the surrounding system gives them tools or retrieved sources to do that.

The practical lesson is straightforward: use AI as a starting point, not as the final authority.

Be especially careful with:

- legal questions
- medical advice
- financial decisions
- security-sensitive code
- statistics and benchmarks
- names, dates, and citations

For low-risk drafting, hallucination may be only an annoyance. For high-risk decisions, it can be a serious problem. The people who use AI well do not blindly trust it. They verify.

## 5. RAG

**RAG** stands for **Retrieval-Augmented Generation**.

It sounds complicated, but the core idea is simple: before the model answers, the system retrieves relevant information and gives it to the model as context.

This solves a common problem. A model may not know your company documents, private notes, latest support policy, or the PDF you just uploaded. Instead of retraining the model every time new information appears, a RAG system does something more practical:

1. Break documents into smaller chunks.
2. Store those chunks in a searchable database, often using embeddings.
3. When a user asks a question, search for the most relevant chunks.
4. Put those chunks into the prompt.
5. Ask the model to answer using that context.

That is the basic flow:

> retrieve useful context, give it to the model, generate an answer.

This is how many "chat with your PDF" tools work. It is also the pattern behind many internal knowledge assistants, customer support bots, and documentation search tools.

Understanding RAG changes how you think about AI products. When a product says the AI "knows your documents," it often means the system can search your documents and place the relevant pieces into the model's context. The base model did not permanently learn everything. The application gave it better context at the right time.

RAG is powerful, but it is not perfect. If retrieval finds the wrong chunks, the answer may still be wrong. If the documents are outdated, the answer may reflect outdated information. If the prompt does not force the model to stay grounded, it may still invent details.

Good RAG systems need good retrieval, clear source handling, and careful verification.

## Why These Terms Matter

These five ideas are small, but they explain a lot:

- **Tokens** explain why prompts, pricing, and length limits work the way they do.
- **Context windows** explain why AI can lose track of long conversations.
- **Temperature** explains why the same prompt can produce safer or more creative answers.
- **Hallucination** explains why confident AI output still needs verification.
- **RAG** explains how AI tools answer questions about your own documents.

You do not need to memorize academic definitions. The goal is practical understanding.

Once these terms click, AI stops feeling like a mysterious black box and starts looking more like a system with constraints. That is when you can use it with better judgment.
