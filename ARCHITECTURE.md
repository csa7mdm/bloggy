# System Architecture

## Overview

Bloggy is a Phoenix 1.7 application designed as an **AI-Native Publishing Platform**. It serves two distinct classes of users:
1.  **Humans**: Via a responsive, server-rendered HTML interface (LiveView).
2.  **Agents**: Via high-density, machine-readable endpoints (`llms.txt`, Context API).

## System Boundaries

```mermaid
graph TD
    User[User / Browser] -->|HTTPS| LB[Load Balancer]
    Agent[AI Agent / LLM] -->|HTTPS| LB
    
    subgraph "Bloggy Platform (Phoenix)"
        LB --> Router
        
        subgraph "Web Layer (Phoenix)"
            Router -->|Browser Request| PageController
            Router -->|Auth Request| AuthPipeline
            Router -->|LiveView| LiveSocket
        end
        
        subgraph "AI Consumption Layer"
            Router -->|GET /llms.txt| LLMController
            Router -->|GET /api/v1/...| ContextController
        end
        
        subgraph "Core Domain (Elixir)"
            ContextController --> Bloggy.Schema
            LiveSocket --> Bloggy.Schema
            Bloggy.Schema -->|Ecto| Repo
        end
    end
    
    Repo -->|TCP 5432| DB[(PostgreSQL + pgvector)]
```

## Core Contexts

### 1. `Bloggy.Accounts`
Handles user identity, registration, and authentication.
- **Key Schemas**: `User`, `Company`
- **Dependencies**: `Bcrypt` for password hashing.

### 2. `Bloggy.Schema`
The primary content domain.
- **Key Schemas**: `Post`
- **Responsibilities**:
    - CRUD operations for content.
    - Markdown storage (body).
    - Taxonomy and Metadata.

### 3. `BloggyWeb`
The presentation layer.
- **Controllers**: Traditional HTTP request/response.
- **LiveViews**: Stateful, real-time UI components.
- **API**: JSON endpoints for external consumption.

## AI Ingestion Pipeline

How AI Agents consume Bloggy content:

1.  **Discovery**: Agent requests `/llms.txt`.
2.  **Mapping**: Server returns a plain-text list of all available resource URLs and descriptions.
3.  **Consumption**: Agent iterates through the list, requesting specific `/api/v1/posts/:id/context` endpoints.
4.  **Ingestion**: Server returns structured JSON with raw Markdown, optimized for vector database embedding.

## Data Flow: Content Creation

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant EditorHook
    participant LiveView
    participant DB

    User->>Browser: Types in Markdown Editor
    Browser->>EditorHook: Capture Input event
    EditorHook->>LiveView: Push "update" event
    LiveView->>LiveView: Update Changeset (Validation)
    User->>Browser: Clicks "Save"
    Browser->>LiveView: Submit Form
    LiveView->>DB: INSERT/UPDATE post
    DB-->>LiveView: {:ok, post}
    LiveView-->>Browser: Redirect to Show Page
```
