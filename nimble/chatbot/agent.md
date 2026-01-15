### Purpose & Intent

- Upcoming chatbot initiative; likely my **first assignment**.
- Current phase is **exploration and validation**.
- Focus on chatbot product / PoC with **social platform integrations**, especially **LINE (Thailand)**.
- Chatbot should interact with backend APIs directly (API-first), not MCP-heavy.

### Technology & Architecture

- **n8n** is currently in use with existing workflows.
- Expectation to:
  - review,
  - validate,
  - and improve or rethink the implementation.
- Explicit concerns:
  - **multi-tenancy** support,
  - collaboration and permission limitations in n8n (free tier).
- Open to:
  - extending n8n, or
  - building a custom solution if needed.
- Stated that building in-house "won’t hurt," especially for scale.

### Infrastructure

- n8n hosted on **EC2 (Sydney)**.
- AWS access via SSO:  
  https://nimblehq.awsapps.com/
- n8n instance:  
  https://workflows.nimblehq.co/

### Ramp-up Resources

- n8n Docs – Workflows: https://docs.n8n.io/workflows/
- n8n Docs – Nodes: https://docs.n8n.io/workflows/components/nodes/

### Access & Tooling

- Credentials shared via 1Password (view-only for exploration).
- Single shared n8n account due to permission constraints.

### Demo / Live Example

Chat with this LINE OA to see the current behavior.

- LINE chatbot demo account: https://line.me/R/ti/p/@904xstnq

### Core Platforms & Links

- LINE Chat Manager: https://chat.line.biz/
- LINE Official Account Manager: https://manager.line.biz/
- LINE Developers Console: https://developers.line.biz/

### Supporting Systems

- **Cal.com** – slot / booking management: https://cal.com/
- **Supabase** – conversation context and state management
- **Okya APIs** – primary business data source

### Chatbot Flow Types

1. **With Agent**
   - Dynamic handling of free-text user messages.
2. **Without Agent**
   - Structured interactions via postback events.
   - Store cards, product cards, buttons.

### Workflow Conventions

- Subflows naming:
  - `_action` → retrieve data and send response back to LINE.
  - `_data` → retrieve data only.

### Current Operating Constraints

- n8n used as the main orchestration layer.
- Changes must be handled carefully due to:
  - shared account usage,
  - limited permissions,
  - lack of real-time collaboration.

## Consolidated Takeaway

- Current setup is **functional but early-stage**.
- n8n enabled fast iteration but introduces:
  - operational brittleness,
  - collaboration friction,
  - scaling and multi-tenancy challenges.
- This initiative is positioned to be **evaluated and evolved**, not locked into the current tooling.

n8n helped validate the flows quickly, but as we think about reliability, multi-tenancy, and LLM evolution, a serverless + queue-based workflow might give us better long-term control.
We could still keep n8n at the edges, but move core orchestration into code.

Chatbots are event-driven systems

1. LINE webhooks → async processing → multiple side effects

- Queues are the correct primitive; visual workflows are not

2. Multi-tenancy is non-negotiable

- n8n makes tenancy an afterthought
- Serverless makes tenancy explicit (tenantId everywhere)

3. LLM workflows change constantly

- Prompts, retrieval logic, tools, evaluation
- These must live in Git, not a UI

4. Operational clarity

- Deterministic retries
- Observability per step
- Easier incident debugging

5. Team scale

- Multiple engineers working safely
- Proper reviews, rollbacks, and environments

If this were a short-lived PoC, n8n would be fine.

### How to talk about this without causing friction

> In the hybrid, n8n becomes optional. We can keep it short-term to reduce risk, but the architecture no longer depends on it.

In the hybrid setup, n8n mostly acts as a pass-through. In that case, QStash plus a thin HTTP ingress could actually be lower risk for January — fewer moving parts and clearer retries. Open to keeping n8n short-term if it helps reduce uncertainty, but it doesn't feel strictly required for delivery safety

## Tenancy in this chatbot system

**Tenancy = the business using the chatbot for their customers.**

In practical terms:

- A **tenant** is a single business / brand (e.g., a restaurant chain).
- Each tenant owns:
  - One LINE Official Account
  - Their own products, stores, promotions
  - Their own chatbot behavior and configuration
- **End users** are that tenant’s customers chatting with the bot.

### Concrete mapping

| Concept   | Example                                     |
| --------- | ------------------------------------------- |
| Tenant    | You&I Suki                                  |
| Channel   | LINE Official Account (You&I Suki)          |
| End users | Customers chatting on LINE                  |
| Data      | Orders, carts, bookings for You&I Suki only |

Another tenant would have:
- A different LINE OA
- Different products, promotions, rules
- Completely separate data and state

Same codebase. Same infrastructure. **Strict isolation.**

### Mental model

```
Platform
├─ Tenant A (Business)
│   ├─ Customer 1
│   ├─ Customer 2
│   └─ Customer N
├─ Tenant B (Business)
│   ├─ Customer 1
│   ├─ Customer 2
│   └─ Customer N
```

### What this implies architecturally

- Every incoming event must have an explicit `tenantId`
- All config, data access, and logic are scoped by `tenantId`
- Infrastructure is shared, behavior and data are isolated

> A tenant is a business that uses the chatbot to serve its own customers, with fully isolated configuration, behavior, and data.

## Using Vector Embeddings for CMS Knowledge

Vector embeddings **can help**, but only if they are introduced carefully and for the right reasons.

### When embeddings make sense

Embeddings add value if:

- CMS content is large or unstructured
- User questions are fuzzy or phrased inconsistently
- Manual tagging is hard to maintain

If CMS content is small and well-structured, embeddings are optional.

### Recommended approach: Hybrid retrieval

Do **not** replace structured lookup. Use embeddings as a fallback.

```
User message
→ Intent detection
→ Structured CMS lookup (type, tags, tenantId)
→ If low confidence or empty result:
→ Vector search (tenant-scoped)
→ Top 3–5 snippets
→ LLM composes the response
```

### Where embeddings should live

- Store embeddings in a vector-capable datastore (e.g. Weaviate, Supabase Vector, OpenSearch)
- Never store them in prompts or workflows
- Always scope by `tenantId`

Example record:

```json
{
  "tenantId": "you-and-i-suki",
  "sourceId": "faq_refund_policy",
  "content": "Refunds are available within 7 days...",
  "embedding": [...],
  "updatedAt": "2025-01-10"
}
```

### Update strategy

- Update embeddings when CMS content changes
- Trigger via CMS webhook or scheduled job
- No real-time sync required for January

### LLM guardrails (still required)

- The LLM must answer only using retrieved context
- If the answer is not present, it must say so and suggest support

Embeddings retrieve information; they do not guarantee correctness.

### January-safe decision rule

- Default: structured CMS retrieval
- Add embeddings only as a fallback if needed

## Non-goals (for January)

- No full rewrite of all existing n8n workflows
- No multi-agent LLM experimentation
- No real-time CMS → embedding sync
- No per-tenant custom models

n8n, if retained, is an edge integration tool — not the system of record, not the orchestrator, and not the place where business logic lives.

## Infra setup

1. **Concept to infrastructure**

   - Use existing infrastructure-templates (Terraform) as the baseline
   - Assume AWS as the cloud provider
   - Start with a monolithic app, not microservices
   - Design should be deployable with their standard patterns (ALB, ECS, RDS, etc.)
   - Intent: Reduce risk by staying within proven infra patterns.

2. **Evaluate AWS-native AI services before external ones**

  - Whether AWS-provided AI services can cover requirements
  - Especially to avoid
    - extra cost
    - added latency
    - unnecessary external dependencies (e.g., OpenAI)
  - This includes:
    - LLMs (Bedrock vs external)
    - Speech services for call booking
  - Intent: Prefer AWS-native options unless there’s a clear reason not to.

3. Call-booking / voice flow is a first-class feature

  - system is not just a LINE chatbot
  - already an AI-powered call-center / booking flow in n8n
  - that flow must be
    - explicitly modeled
    - included in infra and architecture decisions
  - Intent: Avoid designing a chatbot-only architecture that ignores existing functionality.

4. Think in domains when migrating out of n8n

  - Multiple features currently live together in n8n:
    - Chat
    - Call booking
    - AI logic
    - Integrations
  - It may make sense to:	
    - migrate per domain
    - not move everything at once
    - keep boundaries clear even inside a monolith