# Bloggy 2026: Product Roadmap

> [!NOTE]
> This roadmap transforms the current MVP into a standout, AI-native platform by 2026. It focuses on technical excellence, premium UX, and deep AI integration for both consumption (agents reading the blog) and creation (AI assisting the author).

## Horizon 1: Foundation Hardening (The "Missing 20%")
**Goal:** Complete the product fundamentals to make it a viable, secure, and usable blogging platform.

### 1. Core Product Features
- **Public Blog Access:** Create unauthenticated views for `index` and `show` posts.
- **Rich Content Authoring:** Replace simple textareas with a Markdown editor (e.g., EasyMDE) having live preview and image support.
- **Media Management:** Implement S3-compatible storage for post cover images and inline media.
- **Identity & Profiles:** Add email verification, password reset flows, and public author profiles.

### 2. User Experience (UX)
- **Navigation & Brand:** Fix broken asset links (Logo), implement a consistent header/footer for public vs. auth states.
- **Flash & Feedback:** Ensure all actions have clear, animated toast notifications (using the new CoreComponents).
- **Error Pages:** Custom 404/500 functional components instead of generic JSON errors.

### 3. Production Infrastructure
- **Security:** Move secrets to `runtime.exs` strictly. Implement Content Security Policy (CSP) headers.
- **Observability:** Connect LiveDashboard to production metrics. Add request logging.
- **CI/CD:** GitHub Actions for testing, formatting, and Docker container building.

---

## Horizon 2: The 2026 Experience (Standout UI/UX)
**Goal:** Create a "Premium" feel that competes with top-tier platforms like Linear, Vercel, or Substack.

### 1. Visual Language
- **Typography-First Design:** Integration of variable fonts (Inter/Geist) with fluid typography scaling.
- **Theme Engine:** System-aware Dark/Light mode with instant toggling (CSS variables + Tailwind).
- **Micro-Interactions:** extensive use of `Phoenix.LiveView.JS` for optimistic UI updates (instant "Like" feedback, smooth transitions between pages).

### 2. Architecture & Performance
- **LiveView Native:** Prepare backend patterns to support a future mobile app (SwiftUI/Kotlin) sharing the same state.
- **Edge Caching:** Implement stale-while-revalidate patterns for public posts to ensure sub-100ms time-to-first-byte (TTFB) globally.
- **Image Optimization:** Automatic WebP/AVIF conversion and scrset generation for responsive layouts.

---

## Horizon 3: AI-Native Integration
**Goal:** Make the blog a first-class citizen for both *Artificial* and *Human* intelligence.

### 1. AI Readiness (Consumption)
*How AI Agents read your blog*
- **`llms.txt`**: A dedicated route `GET /llms.txt` providing a token-efficient map of the entire blog's content for crawlers.
- **Context API**: `GET /api/v1/posts/:slug/context` returning raw Markdown + high-dimensional metadata optimized for RAG (Retrieval-Augmented Generation) ingestion.
- **Structured Data:** Full JSON-LD implementation (Schema.org `BlogPosting`, `Person`, `BreadcrumbList`) for rich snippets.

### 2. Semantic Search & Discovery
- **Vector Database:** Integrate `pgvector` with Postgres. auto-generate embeddings for every post upon publishing.
- **"Ask this Blog":** A semantic search bar that answers questions based on the blog's content (RAG) rather than just keyword matching.
- **Related Content:** Automatic, semantic recommendations for "Read Next" based on vector similarity.

### 3. AI-Assisted Authoring (Creation)
- **Magic Title:** AI generation of SEO-optimized titles/slugs based on content.
- **Auto-Tagging:** Classification of posts into categories automatically.
- **Summarization:** Auto-generate TL;DR summaries for the top of posts and OpenGraph description tags.

---

---

## Horizon 4: Professionalization & Scale
**Goal:** Operational maturity, specialized documentation, and extensibility.

### 1. Developer Experience & Docs
- **Public API Docs:** Generated via `ExDoc`, hosting schema for the Context API.
- **Architecture Guide:** Detailed diagrams of the system boundaries and AI ingestion flow.
- **Live Demo:** Automatic deployment configurations for Fly.io/Render.

### 2. Operational Excellence (DevOps)
- **CI/CD:** GitHub Actions for automated testing, linting, and security audits.
- **Containerization:** Production-optimized `Dockerfile`.

### 3. Extensibility (Plugins)
- **Plugin System:** A behaviour-based contract (`Bloggy.Plugin`) allowing extensions to hook into lifecycle events (e.g., `on_post_publish`).

---

## Technical Stack Evolution

| Component | Current | 2026 Target | Reason |
|-----------|---------|-------------|--------|
| **Database** | Postgres | Postgres + **pgvector** | Adds native vector search capabilities without new infra. |
| **Search** | SQL `LIKE` | **Hybrid Search** (Keyword + Vector) | Best-in-class retrieval quality. |
| **Styling** | Tailwind CSS | Tailwind **v4** (Oxy) | Faster compile times, better standard CSS integration. |
| **Jobs** | None | **Oban** | Robust background processing for AI tasks & emails. |
| **Testing** | ExUnit | ExUnit + **Wallaby** | Full browser automation testing for critical flows. |

## Implementation Plan (Immediate Next Steps)

1.  **Fix Routes:** Separate Public vs Private scopes correctly.
2.  **Add Editor:** Install a Markdown library.
3.  **Public View:** Create the `BloggyWeb.PostHTML.show` public template.
4.  **Security Audit:** Run `mix soh.check`.
