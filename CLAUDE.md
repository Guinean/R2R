## Testing Guidelines for Agentic Python Projects

### 1. Philosophy

- Write **feature-first tests**, not implementation-bound tests.
- Keep test suites lean and fast—rapid feedback supports velocity.
- Tests exist to **enable refactoring and confidence**, not to block progress.
- Embrace a **Spec ⇄ Code ⇄ Test** workflow—encode behavior as tests first.

### 2. Test Design

- Classify tests by:

  - **Speed**: fast (pure logic) vs. slow (I/O, agent chains).
  - **Isolation**: isolated (mocked) vs. integrated (real dependencies).

- Avoid rigid testing patterns that make refactoring painful.

### 3. Tooling & Hooks

- **Linting & Analysis**: Use `ruff` for linting (avoid pylint/flake8 unless absolutely necessary).
- **Complexity Metrics**: Use `radon` to monitor code complexity.
- **Pre-commit Hook**: Run fast tests + lint + complexity analysis.
- **Pre-push Hook**: Optionally run a broader but still fast test suite.
- **CI Pipeline (future)**: Mirror pre-push tests and include documentation builds, image registries, etc.

### 4. Project Test/Hook Structure (example)

```
.git/hooks/
  pre-commit → ../../scripts/run-hooks.sh
  pre-push   → ../../scripts/run-hooks.sh

scripts/
  run_fast_tests.sh
  lint.sh
  metrics.sh
  run_slow_tests.sh (if needed)
  metrics_and_smells.sh
  hooks/
    pre_commit.sh (reference desired scripts in scripts directory)
    pre_push.sh (reference desired scripts in scripts directory, but optional, can be empty and just has passing code if nothing is referenced)
```

- Hooks simply call these scripts. Scripts should be logically broken and clearly named.

### 5. Maintenance

- Revisit tests periodically—remove or refactor ones that are brittle or unhelpful.
- Use naming and test organization to make maintenance intuitive (see Matklad’s test trace commentary) ([Matklad][4]).

---

[1]: `llm_txt_resources/How to Test.html - "How to Test` - matklad"
[2]: `llm_txt_resources/Unit and Integration Tests.html` - "Unit and Integration Tests - matklad"
[3]: `llm_txt_resources/Vibe Coding Terminal Editor.html` - "Vibe Coding Terminal Editor - matklad"
[4]: `llm_txt_resources/A Trick For Test Maintenance.html` - "A Trick For Test Maintenance - matklad"

## important-instruction-reminders

Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (\*.md) or README files. Only create documentation files if explicitly requested by the User.
