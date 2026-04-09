# Implementation Plan: MVP RSS Reader

**Branch**: `001-mvp-rss-reader` | **Date**: 2026-04-09 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-mvp-rss-reader/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

MVP RSS Reader demonstrates subscription management as the foundation for a feed reader application. Users can add RSS/Atom feed URLs via a simple UI, and the application displays them in a list. The MVP focuses on rapid development of the minimal capability: add subscription + display list. No feed fetching, parsing, or persistence required. Backend uses ASP.NET Core Web API with in-memory storage; frontend uses Blazor WebAssembly.

## Technical Context

**Language/Version**: C# / .NET 6+  
**Primary Dependencies**: ASP.NET Core Web API, Blazor WebAssembly  
**Storage**: In-memory List<T> (no persistence; resets on app restart)  
**Testing**: xUnit or MSTest  
**Target Platform**: Cross-platform: Windows, macOS, Linux (localhost development only)  
**Project Type**: Web application (ASP.NET Core backend + Blazor WASM frontend)  
**Performance Goals**: Sub-second UI updates (< 1 second from click to display)  
**Constraints**: MVP scope only; no production hardening; in-memory storage only  
**Scale/Scope**: Single-user PoC; max 100 subscriptions (no scale testing required)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Constitution**: RSS Feed Reader Constitution v1.0.0

**Principle I: MVP-First Development**  
✅ **PASS**: Spec explicitly defines MVP scope (add + display only), defers persistence, fetching, parsing.  
Foundational phase will clean Blazor template pages before MVP feature work.

**Principle II: Clean Architecture (Backend/Frontend Separation)**  
✅ **PASS**: Architecture enforces clear backend/frontend split via JSON API contracts.  
Backend owns subscription storage (in-memory List); frontend owns UI.  
Sections 7&8 below detail API contract and backend model.

**Principle III: Security by Design (NON-NEGOTIABLE)**  
✅ **PASS**: MVP accepts any URL (no validation per spec).  
Extended-MVP will validate URLs. CORS hardening required: Section 7 documents explicit CORS policy.

**Principle IV: Code Quality & Maintainability**  
✅ **PASS**: TDD preferred. Unit tests for backend API; integration tests for frontend-backend communication.  
No external mocking frameworks for MVP. Code review verifies principles.

**Principle V: Cross-Platform & Incremental Complexity**  
✅ **PASS**: All code runs Windows/macOS/Linux via .NET cross-platform support.  
Build scripts verified on all platforms before release. MVP minimal dependencies.

**Principle VI: Documentation-Driven Development**  
✅ **PASS**: Spec documented before implementation. API contracts explicit (Section 7).  
Local development checklist included (ProjectGoals.md). Quickstart.md will provide end-to-end examples.

## Project Structure

### Documentation (this feature)

```text
specs/001-mvp-rss-reader/
├── plan.md              # This file (/speckit.plan command output)
├── spec.md              # Feature specification
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
│   ├── api-contract.md  # Backend API contract (JSON)
│   └── data-model.json  # Subscription entity example
└── checklists/
    └── requirements.md  # Quality assessment (from /speckit.specify)
```

### Source Code (repository root)

```text
RSSFeedReader/                       # Repository root
├── backend/
│   ├── RSSFeedReader.Api/           # ASP.NET Core Web API project
│   │   ├── Properties/
│   │   │   └── launchSettings.json  # Port config (default: 5151)
│   │   ├── Models/
│   │   │   └── Subscription.cs      # Subscription model
│   │   ├── Services/
│   │   │   └── SubscriptionService.cs # In-memory storage logic
│   │   ├── Controllers/
│   │   │   └── SubscriptionsController.cs # API endpoints
│   │   ├── Program.cs               # Startup + middleware
│   │   └── RSSFeedReader.Api.csproj
│   └── tests/
│       ├── RSSFeedReader.Api.Tests/
│       │   ├── Controllers/
│       │   │   └── SubscriptionsControllerTests.cs
│       │   ├── Services/
│       │   │   └── SubscriptionServiceTests.cs
│       │   └── RSSFeedReader.Api.Tests.csproj
│       └── integration/
│           ├── RSSFeedReader.Integration.Tests/
│           │   ├── ApiTests.cs      # Backend + Frontend communication
│           │   └── RSSFeedReader.Integration.Tests.csproj
│
├── frontend/
│   ├── RSSFeedReader.UI/            # Blazor WebAssembly project (.NET)
│   │   ├── Properties/
│   │   │   └── launchSettings.json  # Port config (default: 5213)
│   │   ├── wwwroot/
│   │   │   ├── appsettings.json     # Client-side config (backend URL)
│   │   │   ├── index.html
│   │   │   └── css/
│   │   ├── Pages/
│   │   │   ├── Index.razor          # Root page (/)
│   │   │   ├── Subscriptions.razor  # Subscription list page
│   │   │   └── NotFound.razor       # 404 page
│   │   ├── Components/              # Shared Razor components
│   │   │   ├── SubscriptionList.razor
│   │   │   └── SubscriptionForm.razor
│   │   ├── Services/
│   │   │   └── SubscriptionApiClient.cs # HTTP client to backend
│   │   ├── Shared/
│   │   │   └── NavMenu.razor        # Navigation menu
│   │   ├── Layout/
│   │   │   └── MainLayout.razor
│   │   ├── App.razor                # Root component
│   │   ├── Program.cs               # Blazor startup
│   │   └── RSSFeedReader.UI.csproj
│   └── tests/
│       └── RSSFeedReader.UI.Tests/
│           ├── Components/
│           │   └── SubscriptionFormTests.cs
│           ├── Services/
│           │   └── SubscriptionApiClientTests.cs
│           └── RSSFeedReader.UI.Tests.csproj
│
├── .gitignore
├── README.md            # Project overview + quick-start
└── sln/
    └── RSSFeedReader.sln # Visual Studio solution
```

**Structure Decision**: Web application (ASP.NET Core backend + Blazor WASM frontend).  
Backend exposes JSON API on port 5151; frontend runs on port 5213 and communicates via HttpClient.  
Separation enables independent testing and future scaling. Build and deployment scripts coordinate both components.

## Phase 0: Research

**Status**: ✅ **COMPLETE** - No NEEDS CLARIFICATION markers in specification.

All technical details resolved by ProjectGoals.md and TechStack.md:
- ✓ Technology stack fixed: ASP.NET Core + Blazor WA SM  
- ✓ Storage approach fixed: in-memory List<T>  
- ✓ Scope boundaries fixed: add + display only (no fetch/parse/persist)  
- ✓ Target platforms fixed: Windows/macOS/Linux via .NET  
- ✓ Testing strategy documented: xUnit unit + integration tests  

**Output**: No separate `research.md` needed (all knowns documented in spec + constitution).

## Phase 1: Design & Contracts

### 1.1 Data Model Design

**Entity: Subscription**

```csharp
public class Subscription
{
    public string Url { get; set; }          // RSS/Atom feed URL (user-provided, no validation)
    public DateTime AddedAt { get; set; }    // Timestamp when added (for ordering)
}
```

**Storage Strategy**: 
In MVP, store subscriptions in a thread-safe `List<Subscription>` in SubscriptionService.  
Each entry preserves insertion order (Subscription.AddedAt timestamp or list index).  
No duplication prevention; duplicate URLs are allowed per spec.

**Output file**: Will create `data-model.md` with full entity documentation.

### 1.2 API Contracts

**Backend API Endpoints**:

```http
POST /api/subscriptions
Content-Type: application/json

{
  "url": "https://example.com/feed.xml"
}

Response: 201 Created
{
  "url": "https://example.com/feed.xml",
  "addedAt": "2026-04-09T14:30:00Z"
}
```

```http
GET /api/subscriptions

Response: 200 OK
[
  {
    "url": "https://example.com/feed.xml",
    "addedAt": "2026-04-09T14:30:00Z"
  },
  {
    "url": "https://another.com/feed.atom",
    "addedAt": "2026-04-09T14:31:00Z"
  }
]
```

**Output file**: Will create `contracts/api-contract.md` with complete endpoint specifications, error codes, and examples.

### 1.3 Frontend-Backend Communication

Frontend will use `SubscriptionApiClient` (HttpClient wrapper) to:
1. POST new subscription URL to backend
2. GET updated subscription list
3. Display list in Blazor component

Error handling: MVP shows generic "Failed" message (no detailed error breakdown per spec).

**Output file**: Will include frontend communication diagram in `quickstart.md`.

### 1.4 Quick-Start Guide

Will create `quickstart.md` with:
- Local development prerequisites (dotnet CLI 6+, browser)
- Build and run commands for backend + frontend separately
- Verification checklist (backend listening, frontend loaded, CORS working)
- First test scenario (add subscription, verify display)

**Output files to be created**:
- ✅ `data-model.md` – Subscription entity definition + C# model
- ✅ `contracts/api-contract.md` – POST/GET endpoint specifications, CORS config, error handling
- ✅ `quickstart.md` – Local development setup, build/run commands, verification checklist

---

## Phase 2: Foundational (Task Generation)

**Purpose**: Establish core project structure and infrastructure before feature implementation.

**CRITICAL TASKS** (must complete before any user story work):

1. **Project Structure Setup**
   - Create solution file with backend and frontend projects
   - Create project structure per diagram above
   - Initialize git tracking for .csproj files

2. **Backend Setup (ASP.NET Core Web API)**
   - Create RSSFeedReader.Api project
   - Configure Program.cs (startup, middleware, dependency injection)
   - Implement SubscriptionService (in-memory List<Subscription>)
   - Implement SubscriptionsController with POST + GET endpoints
   - Configure CORS policy to allow frontend (http://localhost:5213)
   - Test via curl: GET /api/subscriptions returns []

3. **Frontend Setup (Blazor WebAssembly)**
   - Create RSSFeedReader.UI project
   - **⚠️ CRITICAL CLEANUP** (per TechStack.md):
     - Delete `Home.razor`, `Counter.razor`, `Weather.razor` from Pages/
     - Update `NavMenu.razor` to remove demo links
     - Ensure only one page uses `@page "/"` route
     - Run `dotnet clean && dotnet build` to detect routing conflicts
   - Create `SubscriptionApiClient` service (HttpClient wrapper)
   - Create initial Razor components (SubscriptionForm, SubscriptionList)
   - Configure `appsettings.json` with backend URL (localhost:5151)
   - Test: Frontend loads without console errors, can reach backend API

4. **Testing Framework Setup**
   - Create test projects (xUnit)
   - Configure unit test structure
   - Configure integration test structure
   - Verify all tests compile and run

5. **Documentation**
   - Create README.md with setup and run instructions
   - Copy quickstart.md to repo root for developer reference
   - Add local development checklist (from ProjectGoals.md) to README

6. **Cross-Platform Verification**
   - Run full build on Windows
   - Run full build on macOS
   - Run full build on Linux
   - Verify all three platforms build without warnings

**Checkpoint**: Foundation ready
- ✅ Solution compiles without warnings
- ✅ Backend and frontend projects created
- ✅ CORS configured
- ✅ API endpoints exposed
- ✅ Frontend loads and communicates with backend
- ✅ All tests pass
- ✅ README.md complete
- ✅ Cross-platform build verified

**→ User story implementation can now begin in parallel (Phase 3)**

**Note**: Phase 2 output (tasks) will be generated by `/speckit.tasks` command.



