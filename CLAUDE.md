# Project context (read this first, every session)

This repo is one of 5 flagship portfolio projects for a GitHub profile aimed at an AI engineer / CTO path. The profile must show production engineering, system architecture, cost optimization and security, through decisions and measured evidence, not feature lists.

The owner works in the KEAL framework (Koukoui Enterprise AI Lifecycle): four gates (Discovery, Feasibility, Development, Governance), each needing a self sign-off backed by an evidence link. Notion is the source of truth for tasks and status (links below).

## Hard constraints
1. **Free tiers only.** Never add a paid service, a paid dependency, or a step that needs a payment method. If something seems to need paying, stop and propose a free alternative.
2. **No secrets** in the repo, frontend bundles, logs or commits. Use `.env.example`, platform secret stores and a pre-commit secret scan (gitleaks).
3. **Never fabricate or round up numbers.** Every figure in the README or docs must trace to committed data or a logged run. Label estimates as estimates. Record the date for every price or limit.
4. Provider limits and model names live in **config**, not in code.
5. **Never run model-generated or untrusted code on the host.** Use an isolated container with no network.
6. Use **synthetic data only** for anything resembling personal data.

## How to work
- Start each session by reading this file and `docs/`. Check the Notion Build Tasks for this project (if the Notion connector is available) and take the lowest-order "To do" task.
- Run feasibility tests first. If one fails, stop and report before building on that assumption.
- For architecture-impacting choices, write a short ADR in `docs/adr/` (context, options, decision, cost) and ask the owner before committing to it.
- Prefer the smallest implementation that passes the test. Keep commits small with clear messages.
- Write tests. Where it makes sense, the local dev path is one command (Docker Compose or a make target).
- A task is **Done only with evidence**: a commit, test output, chart or run log. Put the link in the Notion task's Evidence URL.
- If unsure about a provider limit or API detail, check the official docs and say what you verified. Anything marked **VERIFY** must be confirmed before you rely on it.
- When using the Notion connector: set Status to "In progress" when you start a task, "Done" (plus Evidence URL) when finished, and put decisions in Notes. Never delete rows.

## Required in every repo
README (live demo link at the top, architecture diagram, results, cost table, limitations), `docs/adr/`, `docs/threat-model.md`, `docs/ops.md` (monitoring, rollback), `docs/keal-gates.md` (gates passed, with evidence links).

## Demo rules
The live demo shows its evidence, has a graceful fallback for every failure and budget state, shows a privacy notice, and enforces rate limits. It never shows a raw error page.

Notion links: Command Center https://app.notion.com/p/3fde9a5ffec081a4b7c4f59a7092dba7 , Build Tasks https://app.notion.com/p/0043b09ab6e047c9b90ab8662936e183

---

# Project: Hybrid GraphRAG Engine (Vector + Knowledge Graph)
Notion page (full brief): https://app.notion.com/p/3fde9a5ffec08108bbceddecda653cb6

## Goal
Query complex technical documents with graph traversal plus vector similarity, and show it beats vector-only RAG on multi-hop questions with measured evidence. Live demo uses a small fixed sample corpus.

## Architecture
Cloudflare Worker orchestrates: query embedding → Neo4j Aura Free (graph + vector) → context → Groq generation → answer with the retrieved graph path and chunks shown.

## VERIFY before building (early feasibility test)
- Aura Free: can a Worker run Cypher over an HTTP query API? Is a vector index available on the free tier?
- Aura Free limits conflict between sources (50K nodes / 175K relationships vs. 200K / 400K). Plan for the smaller figure.
- Aura Free auto-pauses after about 72 hours of inactivity and is deleted if paused over 30 days. Mitigate: commit a graph export, detect a paused DB and fall back to recorded examples, consider a scheduled keep-alive (VERIFY Worker cron triggers on the free plan).
- Query embeddings: Workers AI embedding model (watch the free daily allowance) or a small model in the visitor's browser (VERIFY).

## Rules
- Do graph extraction/ingestion once, offline, and commit the resulting graph. Do not re-ingest at demo time.
- Build the **vector-only baseline first**; the hybrid must beat it on a multi-hop question set (answer accuracy, retrieval recall, faithfulness).
- Choose a corpus with a clear license and record it.
- Reuse the router demo's Groq budget guardrails and recorded fallback.
- Fallback to vector-only retrieval if the graph query fails.

## Task order (mirror in Notion Build Tasks)
1. Worker → Aura HTTP query + vector query test (feasibility, do this FIRST)
2. Corpus + license
3. Graph schema (ADR)
4. Vector-only baseline
5. Hybrid retriever
6. Evaluation set + results
7. Graph export committed
8. Demo showing retrieved evidence
9. Threat model (injection through documents, poisoned corpus, graph query injection), ops note
