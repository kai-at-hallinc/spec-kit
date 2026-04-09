<!-- SYNC IMPACT REPORT
═══════════════════════════════════════════════════════════════════════════════

VERSION CHANGE: [Initial] → 1.0.0 (MAJOR: First constitution for RSS Feed Reader)

NEW CONSTITUTION CREATED:
✓ Project: RSS Feed Reader (ASP.NET Core + Blazor WebAssembly)
✓ 6 Principles created (MVP-First, Clean Architecture, Security, Code Quality, 
  Cross-Platform, Documentation-Driven)
✓ Development Quality Gates section added
✓ Technology Stack section added
✓ Governance section completed

AFFECTED TEMPLATES:
✓ plan-template.md     - Already includes "Constitution Check" gate, compatible
✓ spec-template.md     - Uses constitution principles implicitly, no updates needed  
✓ tasks-template.md    - Phase 2 "Foundational" aligns with Clean Architecture principle
✓ No command files reference outdated constitution terms

FOLLOW-UP NOTES:
- Constitution defaults to 6 principles (may be reduced/expanded in amendments)
- Technology stack locked for MVP; Extended-MVP amendments will expand
- Security principle marked NON-NEGOTIABLE as per user guidance

═════════════════════════════════════════════════════════════════════════════
-->

# RSS Feed Reader Constitution

## Core Principles

### I. MVP-First Development
All development begins with the minimal viable scope, clearly documented and user-approved before implementation. 
For this project: subscription management (add URL, display list) precedes feed fetching, persistence, and advanced 
features. Each phase must be completable and verifiable independently. No feature is added before its prior phase is fully 
functional. Deferred features (persistence, removal, background polling) are explicitly listed and tracked, not left ambiguous.

### II. Clean Architecture (Backend/Frontend Separation)
Architecture MUST enforce clear separation between ASP.NET Core Web API backend and Blazor WebAssembly frontend. 
Backend owns data management, feed operations, and business logic. Frontend owns UI interaction, state presentation, 
and user feedback. Communication is exclusively via documented API contracts (JSON). No backend code runs in browser; 
no UI code in backend. This separation enables independent testing, scaling, and future persistence/polling without 
redesign.

### III. Security by Design (NON-NEGOTIABLE)
Security decisions are made upfront, not retroactively. All feed URLs are validated before processing. Network requests 
use HTTPS-only for external feeds. No unvalidated HTML is rendered. Feed parsing handles malformed XML gracefully 
without data corruption or crashes. CORS is explicitly configured (not overly permissive). Error messages never leak 
sensitive details (e.g., file paths, internal errors). Code review MUST verify security assumptions before merge.

### IV. Code Quality & Maintainability
Code must be readable, testable, and maintainable. Tests are written before or alongside code (TDD preferred). 
Unit tests cover business logic; integration tests verify API contracts and backend-frontend communication. 
Naming is explicit; no cryptic abbreviations. Complexity is justified and documented. Dead code and experimental branches 
are removed before merge. Refactoring for clarity is encouraged; refactoring for "fun" without purpose is deferred. 
Code reviews focus on logic, security, and maintainability, not style alone.

### V. Cross-Platform & Incremental Complexity
All code runs on Windows, macOS, and Linux without platform-specific hacks. Build and test scripts are verified on all 
target platforms before release. MVP has minimal dependencies; Extended-MVP carefully adds only necessary libraries 
(e.g., System.ServiceModel.Syndication for parsing). Dependencies are justified in documentation. Future features 
(database, background jobs, advanced UI) are architected so they fit incrementally without rewriting core logic.

### VI. Documentation-Driven Development
Requirements are documented before code is written. Decision rationale (tech choices, trade-offs, deferred features) 
is captured. Local development checklists verify setup before testing. API contracts are explicit (request/response 
examples, error codes). When ambiguity arises, the architecture decision document supersedes assumptions. 
README.md stays current; examples work end-to-end.

## Development Quality Gates

Before any code merge:
- No compiler warnings or unused variables
- All tests (unit + integration) pass locally on developer's platform
- Code review confirms security assumptions are met
- Deferred features remain in backlog, not sprinkled in MVP code
- Cross-platform build verified if platform-specific code is added

## Technology Stack (Locked for MVP)

**Backend**: ASP.NET Core Web API (.NET 6+), in-memory storage (List<T>)  
**Frontend**: Blazor WebAssembly, C#, single-page app  
**Feed Parsing** (Extended-MVP only): System.ServiceModel.Syndication  
**Testing**: xUnit or MSTest, no external mocking frameworks for MVP  
**Local Development**: dotnet CLI, Visual Studio Code or Visual Studio

## Governance

This constitution supersedes all conflicting development practices. All pull requests MUST verify compliance with 
Principles I–VI before merge. If a principle conflicts with a deadline or feature request, the conflict is explicitly 
documented and escalated; the principle is NOT waived silently. Amendments to this constitution require:

1. Written justification (why is the change necessary?)
2. Impact analysis (which principles or practices are affected?)
3. Migration plan (how do in-flight changes adapt?)
4. Version bump according to semantic versioning

**Version**: 1.0.0 | **Ratified**: 2026-04-09 | **Last Amended**: 2026-04-09
