---
applyTo: "**"
description: "Core Copilot coding instructions for this repository."
---

# Copilot Core Instructions for minimal-data-science

## Scope
- This repository is focused on minimal, reproducible data-science workflows.
- Prefer clear, small, and testable changes over broad refactors.

## Coding Style
- Use Python type hints where practical.
- Keep functions short and single-purpose.
- Avoid adding new dependencies unless clearly justified.

## Data and Reproducibility
- Do not hardcode secrets, API keys, or local absolute paths.
- Prefer relative paths from project root.
- Keep notebooks and scripts reproducible; document assumptions in comments.

## Project Conventions
- Follow existing project structure (`src/`, `tests/`, `notebooks/`, `data/`).
- Add or update tests when changing behavior.
- Keep documentation concise and actionable in `README.md` or `docs/`.

## Safety
- Never expose credentials in code, logs, or sample outputs.
- If environment variables are required, document expected variable names.

## Explanation Quality
- Make explanations educational for data scientists, not just code-first.
- When generating code, explain intent, trade-offs, and implementation details clearly and step by step.
- Highlight best practices and de facto standards relevant to the language, framework, and data-science workflow.
