# Bloggy 🤖

> **The AI-Native Publishing Platform**
> Built with Phoenix 1.7, Tailwind 3, and LiveView.

[![Elixir](https://img.shields.io/badge/Elixir-1.14+-purple.svg)](https://elixir-lang.org)
[![Phoenix](https://img.shields.io/badge/Phoenix-1.7-orange.svg)](https://www.phoenixframework.org/)
[![AI Ready](https://img.shields.io/badge/AI-Ready-green.svg)](/llms.txt)

Bloggy is a modern blogging engine designed for the **Agentic Web**. It treats AI Agents as first-class citizens alongside human readers, offering specialized endpoints for efficient machine reading and RAG ingestion.

![Bloggy Logo](priv/static/images/logo.svg)

## 🚀 Key Features

- **For Humans:**
    - 🌗 **Dark Mode**: System-aware theme engine.
    - 📝 **Rich Editor**: Markdown editing with EasyMDE.
    - ⚡️ **LiveView**: Fast, SPA-like navigation without client-side complexity.
    - 🔐 **Secure**: Role-based authentication (Guardian).

- **For Agents:**
    - 🗺 **`llms.txt`**: Standardized content map for crawlers.
    - 🧠 **Context API**: RAG-optimized JSON endpoints delivering raw tokens.
    - 🔍 **Semantic HTML**: Clean structure for easy parsing.

## 🛠 Getting Started

### Prerequisites
- Elixir 1.14+
- PostgreSQL 12+
- Node.js 18+

### Quick Start

1.  **Setup dependencies:**
    ```bash
    mix deps.get
    cd assets && npm install && cd ..
    ```

2.  **Setup Database:**
    ```bash
    # Ensure Postgres is running
    mix ecto.setup
    ```

3.  **Run Server:**
    ```bash
    mix phx.server
    ```

Visit `http://localhost:4000` to start writing.

## 🤖 AI Integration Guide

### Discovery (`/llms.txt`)
A high-density text file listing all crawlable content.
`GET http://localhost:4000/llms.txt`

### Consumption (`/api/v1/context`)
Fetch raw content optimized for vector embeddings.
`GET http://localhost:4000/api/v1/posts/:id/context`

**Response:**
```json
{
  "id": 2,
  "title": "The Future of AI Blogging",
  "metadata": {
    "token_estimate": 450,
    "source": "bloggy-context-api-v1"
  },
  "content": {
    "format": "markdown",
    "body": "# Deep Dive..."
  }
}
```

## 📐 Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed system diagrams and boundary definitions.

## 🧪 Testing

```bash
# Run unit and integration tests
mix test
```

## License

MIT
