## **Purpose**

Keep the main purpose in mind:

- Help others through clear, thoughtful communication.
- Write as if you are guiding a colleague through the task, explaining decisions and next steps as they arise.
- Make concepts easy to grasp, even for readers with no prior knowledge of the subject.
- Reduce friction wherever it exists.

## **Before Writing**

### **Empathize with Your Audience**

Think about your readers:

- What level of knowledge can you expect?
- Do they understand the terms you are using?
- What do they already know?
- What do they need to learn?

Ask yourself:

> What should someone be able to do by the end of this guide?
> 

Work backwards from that outcome. Identify the steps required to reach the goal, then document those steps.

## **How to Start Writing**

### **Get to Know the Topic**

- If you did not build the thing you are documenting, ask questions until you understand it well enough to explain it clearly.
- If you did build it, ask someone who was not deeply involved to question you. Their questions will reveal gaps, assumptions, and ambiguities that the documentation needs to address.

## **Overcome Blank Page Fear**

To avoid starting from nothing:

- Write a few bullet points describing what you want to cover.
- Or write headings that outline the structure of the guide in the order they should appear.

This gives you something concrete to react to and expand, making it easier to start writing.

# **General Rules**

## **Set Expectations**

Be explicit about what the content will help the reader do.

Clearly state what the reader will have accomplished by the end of the guide. Listing two or three outcomes is often sufficient.

*✅ What you’ll accomplish*

*By the end of this guide, you will:*

- *Understand how the API authentication flow works*
- *Be able to make a successful authenticated request*
- *Know where to find common error responses*

*❌ This guide explains authentication.*

## **Make Content Skimmable**

- State key points at the start of the document.
- Use clear headings to help readers quickly find what they need.

*✅  Key points*

- *You must create an API key before making requests*
- *Requests fail without the Authorization header*
- *Tokens expire after 24 hours*

*❌  This document describes how authentication works, how to create keys, how to use them in requests, and how to debug issues that might come up during development.*

## **Avoid Implicitly Downplaying Difficulty**

Avoid words such as *simply*, *easily*, *just*, and *quickly*. These can be discouraging and dismissive.

**Example:**

❌ *You just need to have your own website or be interested in setting one up.*

✅ *To join, you should be interested in personal websites. You do not need to have a site.*

## **Use terminology consistently**

- Use the same terms, abbreviations, and acronyms throughout the document.

*✅ This guide uses the term **API key** throughout. Do not confuse API keys with access tokens.*

*❌ Generate a key, then use the token in your request headers.*

## **Use Examples Thoughtfully**

### **Tutorials**

- Use a single, clear example throughout the guide.

### **Reference Documentation**

- Be example-agnostic where possible.
- Use minimal, modular examples only when needed to clarify edge cases.

You may mention multiple use cases in an introduction, but focus on one example when demonstrating usage.

Good examples are:

1. Relevant to the software’s capabilities
2. Well defined
3. Intuitive, requiring little background knowledge
4. Relevant to the target audience

## **Abbreviations**

Spell out abbreviations on first use, followed by the shortened form in parentheses.

Example: *Retrieval Augmented Generation (RAG)*

*✅ The system uses Retrieval Augmented Generation (RAG) to improve responses.*

*RAG combines retrieved documents with model output.*

*❌ The system uses RAG to improve responses.*

## **Sentence and Paragraph Structure**

### **Run-on Sentences**

Shorten long sentences where possible. Ensure clear connections between ideas.

Be cautious with sentences starting with *this* or *it*. The reference should always be unambiguous.

*✅ The request fails if the token is missing. This happens because the server cannot identify the client.*

*❌ The request fails if the token is missing which happens because the server cannot identify the client and therefore returns an error.*

### **Short Paragraphs**

- Keep paragraphs to a few sentences.
- Focus each paragraph on a single idea.
- Reduce cognitive load wherever possible.

*✅ Rate limits protect the system from abuse. Each API key has a fixed request quota per minute.*

*❌ Rate limits exist to protect the system from abuse and ensure fair usage across clients while also preventing performance degradation under heavy load scenarios.*

## **Step-by-Step Explanations**

Explain what long code snippets do, step by step.

Text explanations help readers reinforce understanding, especially if they are not comfortable with the code.

*✅* 

1. *The code creates a client instance.*
2. *It adds an authorization header using your API key.*
3. *The request is sent to the /analyze endpoint.*

*❌ As you can see, the code handles everything automatically.*

## **Use Simple Words**

Prefer simple, direct language.

- *e.g.: use* instead of *utilize*

*✅ Use this function to send data to the server.*

*❌ Utilize this function to facilitate data transmission to the server.*

## **Use Visuals and Outputs**

Support explanations with:

- Code outputs
- Screenshots
- Diagrams

Use visuals only when they directly support understanding.

## **Ask for Feedback**

Have someone review the documentation before publishing. A fresh perspective helps catch unclear assumptions and mistakes.

## **Challenge Assumptions**

Assume some level of familiarity, but regularly question whether that assumption is valid.

Example:

A guide titled *“How to Analyze Product Color in Quality Assurance Processes”* should not assume the reader knows that computer vision is the solution.

### **Jargon Usage**

Only use terms that are:

1. Relevant
2. Defined clearly on first use
3. Written in full before abbreviations are introduced

Use patterns such as:

> X is Y. This means…
> 

*✅ Embeddings are numerical representations of text. This means similar text has similar embeddings.*

*❌ We store embeddings and compare them later.*

## **Voice and Clarity**

### **Active vs Passive Voice**

Use active voice where possible, but prioritize clarity over rigid rules

✅ *You can run custom object detection, segmentation, and classification models for identifying visual data specific to your domain.*

❌ *This API is designed to let you run custom object detection, segmentation, and classification models for identifying visual data specific to your domain.*

### **Avoid Ambiguous Pronouns**

Do not use pronouns when the reference is unclear.

*✅ The API returns an error if the **image format** is unsupported.*

*❌ It returns an error if it is unsupported.*

## **Use Fewer Words, Not Less Meaning**

Say what you need to say in as few words as possible.

Ask yourself:

> Could this be expressed more simply?
> 

However, spend words where they reduce confusion. The goal is reduced cognitive load, not extreme brevity.

*✅ The request fails without an API key.*

*❌ In the event that an API key is not provided, the request will not succeed.*

## **Avoid Superfluous Language**

Direct language is clearer and more engaging.

✅ *I asked for a specific format, so as to ensure the prompt was easy to parse.*

❌  *I asked for a specific format, to aid in parsing the prompt*

## **Lists**

### **When to Use Lists**

- Use ordered lists for sequences or steps.
- Use unordered lists for related points.

Lists are useful because they:

- Are easy to skim
- Improve comprehension
- Highlight key information

### **Balance**

- Do not rely on lists as the primary explanation method.
- Use lists when the structure is genuinely list-shaped.
- Convert lists to paragraphs when they would read more clearly as prose.

*✅ To get started, you need:*

- *An API key*
- *Python 3.9 or later*
- *Internet access*

*❌ To get started, you need an API key, Python 3.9 or later, and internet access, all of which must be properly configured.*

## **Callout Boxes**

Use callouts sparingly.

### **Types**

- **Critical** – critical information (use rarely)
- **Warning** – important risks or instability
- **Note** – contextual or supporting information
- **Tip** – helpful optimizations or shortcuts

Overuse reduces effectiveness.

## **Code Snippets and Technical Details**

### **Dependencies**

Clearly state required dependencies and how to install them.

*✅  Dependencies*

- *Python 3.9+*
- *requests library (pip install requests)*

*❌ Make sure you have the necessary apps installed.*

### **Minimum Viable Code**

Use the minimum amount of code required to accomplish the task.

- Prefer multiple smaller snippets over one long snippet.
- Separate core tasks from auxiliary tasks.

Explain:

- What the code does
- What values must be substituted
- Where those values come from (e.g., API keys)

Document limitations such as:

- Rate limits
- SDK availability
- Missing properties
- Deprecation status

## **Duplicate Information**

Identify canonical (“pillar”) content and link to it instead of repeating it.

Duplicate content only when it improves usability, such as in end-to-end tutorials.

Always ask:

> Is this documented elsewhere, and should I link to it instead?
> 

Document once. Reference anywhere.