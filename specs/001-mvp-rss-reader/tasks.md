# Tasks: MVP RSS Reader

**Input**: Design documents from `/specs/001-mvp-rss-reader/`  
**Prerequisites**: plan.md ✅, spec.md ✅, data-model.md ✅, contracts/api-contract.md ✅, quickstart.md ✅

**Organization**: Tasks grouped by phase (Setup → Foundational → User Stories → Polish)

## Format Reference

- **[ID]** – Task sequence number (T001, T002, etc.)
- **[P]** – Parallelizable with other tasks
- **[Story]** – User story assignment (US1 = User Story 1, US2 = User Story 2)
- Test tasks OPTIONAL; generated where helpful for MVP validation

---

## Phase 1: Setup (Project Initialization)

**Purpose**: Create solution structure, initialize projects, configure build environment

**Deliverables**: Solution file, project files, basic configuration

- [ ] T001 Create solution file `RSSFeedReader.sln` at repository root
- [ ] T002 [P] Create backend project `backend/RSSFeedReader.Api/RSSFeedReader.Api.csproj` (ASP.NET Core Web API template)
- [ ] T003 [P] Create frontend project `frontend/RSSFeedReader.UI/RSSFeedReader.UI.csproj` (Blazor WebAssembly template)
- [ ] T004 [P] Create backend unit test project `backend/tests/RSSFeedReader.Api.Tests/RSSFeedReader.Api.Tests.csproj` (xUnit)
- [ ] T005 [P] Create backend integration test project `backend/tests/RSSFeedReader.Integration.Tests/RSSFeedReader.Integration.Tests.csproj` (xUnit)
- [ ] T006 [P] Create frontend unit test project `frontend/tests/RSSFeedReader.UI.Tests/RSSFeedReader.UI.Tests.csproj` (xUnit)
- [ ] T007 Add all projects to solution file `RSSFeedReader.sln`
- [ ] T008 Configure .gitignore for C# project file
- [ ] T009 Verify solution builds: `dotnet build RSSFeedReader.sln` (expect 0 warnings)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish core infrastructure before any feature implementation

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### 2A: Backend Project Setup

- [ ] T010 Configure `backend/RSSFeedReader.Api/Program.cs` with ASP.NET Core startup and middleware
- [ ] T011 Add `backend/RSSFeedReader.Api/Properties/launchSettings.json` with backend port configuration (default: 5151)
- [ ] T012 Add NuGet packages to backend project: none required for MVP (ASP.NET Core + System.Serialization included)
- [ ] T013 Create backend model `backend/RSSFeedReader.Api/Models/Subscription.cs` per data-model.md specification (Url: string, AddedAt: DateTime)
- [ ] T014 Create backend service `backend/RSSFeedReader.Api/Services/SubscriptionService.cs` with in-memory List<Subscription> and methods AddSubscription() + GetAllSubscriptions()
- [ ] T015 [P] Create backend controller `backend/RSSFeedReader.Api/Controllers/SubscriptionsController.cs` with POST /api/subscriptions and GET /api/subscriptions endpoints per api-contract.md
- [ ] T016 Configure CORS policy in `backend/RSSFeedReader.Api/Program.cs` to allow `http://localhost:5213` (frontend origin)
- [ ] T017 Add dependency injection for SubscriptionService in `Program.cs`
- [ ] T018 Test backend API manually: `dotnet run --project backend/RSSFeedReader.Api/` then `curl http://localhost:5151/api/subscriptions` (expect empty array [])

### 2B: Frontend Project Setup (⚠️ CRITICAL TEMPLATE CLEANUP)

- [ ] T019 Create Blazor WebAssembly config `frontend/RSSFeedReader.UI/wwwroot/appsettings.json` with ApiBaseUrl: "http://localhost:5151"
- [ ] T020 [P] Add `frontend/RSSFeedReader.UI/Properties/launchSettings.json` with frontend port configuration (default: 5213)
- [ ] T021 Update `frontend/RSSFeedReader.UI/Program.cs` to register HttpClient service with ApiBaseUrl from appsettings.json
- [ ] T022 **[CRITICAL]** Delete `frontend/RSSFeedReader.UI/Pages/Home.razor` (conflicts with root route)
- [ ] T023 **[CRITICAL]** Delete `frontend/RSSFeedReader.UI/Pages/Counter.razor` (demo page, not needed)
- [ ] T024 **[CRITICAL]** Delete `frontend/RSSFeedReader.UI/Pages/Weather.razor` (demo page, not needed)
- [ ] T025 **[CRITICAL]** Update `frontend/RSSFeedReader.UI/Shared/NavMenu.razor` to remove demo page navigation links
- [ ] T026 **[CRITICAL]** Verify routing: Run `dotnet clean && dotnet build frontend/RSSFeedReader.UI/RSSFeedReader.UI.csproj` and check for 0 routing conflicts (no "ambiguous route" errors)
- [ ] T027 Create frontend service `frontend/RSSFeedReader.UI/Services/SubscriptionApiClient.cs` (HttpClient wrapper) with methods AddSubscription(url) and GetSubscriptions()
- [ ] T028 [P] Create Blazor component `frontend/RSSFeedReader.UI/Components/SubscriptionForm.razor` with text input for URL and "Add Subscription" button
- [ ] T029 [P] Create Blazor component `frontend/RSSFeedReader.UI/Components/SubscriptionList.razor` to display list of subscriptions in order added
- [ ] T030 Create Blazor page `frontend/RSSFeedReader.UI/Pages/Index.razor` (root route `/`) that contains SubscriptionForm + SubscriptionList components
- [ ] T031 Test frontend loads: `dotnet run --project frontend/RSSFeedReader.UI/` then open browser to http://localhost:5213 and verify no console errors (F12 DevTools)

### 2C: Testing Framework Setup

- [ ] T032 [P] Add xUnit to `backend/RSSFeedReader.Api.Tests/` project file (dotnet add package xunit xunit.runner.visualstudio)
- [ ] T033 [P] Add xUnit to `backend/RSSFeedReader.Integration.Tests/` project file
- [ ] T034 [P] Add xUnit to `frontend/RSSFeedReader.UI.Tests/` project file
- [ ] T035 Create test base class `backend/RSSFeedReader.Api.Tests/TestFixture.cs` for setting up test dependencies
- [ ] T036 Create integration test setup `backend/RSSFeedReader.Integration.Tests/ApiTestsSetup.cs` for frontend-backend communication tests
- [ ] T037 Verify all test projects compile: `dotnet build backend/RSSFeedReader.Api.Tests/RSSFeedReader.Api.Tests.csproj` (expect 0 warnings, 0 errors)
- [ ] T038 Run test suite (empty): `dotnet test RSSFeedReader.sln` (expect 0 tests, 0 failures)

### 2D: Documentation & README

- [ ] T039 Create `README.md` at repository root with project overview, prerequisites, build/run instructions (use quickstart.md as template)
- [ ] T040 Add local development checklist from ProjectGoals.md to README.md
- [ ] T041 Create `.github/DEVELOPMENT.md` with contribution guidelines referencing constitution.md

### 2E: Cross-Platform Verification

- [ ] T042 **[Windows]** Run full build: `dotnet build RSSFeedReader.sln` on Windows 10/11 (expect 0 warnings, 0 errors)
- [ ] T043 **[macOS]** Run full build: `dotnet build RSSFeedReader.sln` on macOS 12+ (expect 0 warnings, 0 errors)
- [ ] T044 **[Linux]** Run full build: `dotnet build RSSFeedReader.sln` on Ubuntu 20.04+ (expect 0 warnings, 0 errors)

**Checkpoint**: Foundation ready

✅ **Gate criteria** (MUST ALL PASS before proceeding to Phase 3):
- Solution compiles without warnings on all platforms
- Backend API responds to `GET /api/subscriptions` with empty array
- Frontend loads in browser without console errors
- CORS configured and tested (frontend can communicate with backend)
- All test projects compile and run (0 tests, 0 failures = pass)
- README.md complete with setup instructions

**→ User story implementation phases CAN BEGIN IN PARALLEL after this gate**

---

## Phase 3: User Story 1 - Add Feed Subscription (Priority: P1)

**Goal**: User can add a feed subscription by pasting a URL, and it is stored in memory (visible until app restart)

**Independent Test**: Launch backend + frontend, enter URL in form, click "Add Subscription", verify URL appears in list within 1 second

**Success Criteria**:
- ✅ SubscriptionForm component accepts text input and has "Add" button
- ✅ Backend POST /api/subscriptions accepts URL and stores it
- ✅ UI updates immediately with new subscription in list
- ✅ Input field is cleared after adding
- ✅ Multiple subscriptions can be added sequentially
- ✅ Subscriptions persist in memory during session (no page refresh loss until restart)

### 3A: Backend Implementation - Add Subscription Endpoint

- [ ] T045 Implement `SubscriptionService.AddSubscription(string url)` method: create Subscription object with Url + AddedAt timestamp, add to List<Subscription>
- [ ] T046 Implement `SubscriptionsController.PostSubscription(AddSubscriptionRequest request)` method: call SubscriptionService.AddSubscription(), return 201 Created with subscription object
- [ ] T047 Add request validation to SubscriptionsController: reject empty URL (return 400 Bad Request)
- [ ] T048 Test manually via curl: `POST /api/subscriptions` with `{"url": "https://example.com/feed"}` (expect 201 + subscription in response)
- [ ] T049 [US1] Test: Unit test `SubscriptionServiceTests.AddSubscription_ValidUrl_AddsToList` verifies SubscriptionService adds subscription correctly
- [ ] T050 [US1] Test: Unit test `SubscriptionsControllerTests.PostSubscription_ValidUrl_Returns201` verifies controller returns 201 status

### 3B: Frontend Implementation - SubscriptionForm Component

- [ ] T051 Create form input binding in `SubscriptionForm.razor`: `@bind-Value="inputUrl"` for text field
- [ ] T052 Create "Add Subscription" button in `SubscriptionForm.razor` with `@onclick="HandleAddSubscription"` handler
- [ ] T053 Implement `HandleAddSubscription()` in SubscriptionForm code-behind: call SubscriptionApiClient.AddSubscription(inputUrl), clear inputUrl field, call parent callback
- [ ] T054 Add error handling to SubscriptionForm: catch HttpRequestException and display "Failed to add subscription" message
- [ ] T055 Test manually: Enter URL in form, click "Add", verify input field clears (no visual confirmation yet)
- [ ] T056 [US1] Test: Unit test `SubscriptionFormTests.HandleAddSubscription_ValidUrl_CallsApiClient` verifies form calls API client

### 3C: Frontend-Backend Integration - Add Subscription Flow

- [ ] T057 Implement `SubscriptionApiClient.AddSubscription(string url)` method: POST to `{apiBaseUrl}/api/subscriptions` with `{"url": url}`, return parsed response
- [ ] T058 Create request/response DTO classes: `AddSubscriptionRequest`, `SubscriptionResponse` for JSON serialization
- [ ] T059 Test via Postman or curl: Add 2 URLs via API, verify both are returned (not yet tested via UI)
- [ ] T060 [US1] Test: Integration test `ApiTests.AddSubscription_ValidUrl_ReturnsCreatedSubscription` verifies end-to-end POST flow
- [ ] T061 [US1] Test: Integration test `ApiTests.AddSubscription_ThenGetSubscriptions_ReturnsList` verifies subscription appears in GET response

### 3D: User Story 1 End-to-End (Manual Testing)

- [ ] T062 Start backend: `dotnet run --project backend/RSSFeedReader.Api` on port 5151
- [ ] T063 Start frontend: `dotnet run --project frontend/RSSFeedReader.UI` on port 5213
- [ ] T064 Open browser to http://localhost:5213, verify no console errors
- [ ] T065 **Test Scenario 1**: Enter "https://devblogs.microsoft.com/dotnet/feed/" and click "Add Subscription"
- [ ] T066 Verify subscription appears in list within 1 second (SC-001 ✅)
- [ ] T067 Verify input field is cleared after adding
- [ ] T068 **Test Scenario 2**: Add second URL "https://www.reddit.com/r/csharp/.rss"
- [ ] T069 Verify both subscriptions appear in list in order added (T068 after T067)
- [ ] T070 Verify no console errors during any operation (SC-006 ✅)

---

## Phase 4: User Story 2 - Display Subscription List (Priority: P1)

**Goal**: User can see all subscriptions in a readable list format, in the order they were added

**Independent Test**: Add 3 subscriptions, verify all 3 appear in list in correct order, refresh page and verify list persists during session

**Success Criteria**:
- ✅ SubscriptionList component displays all subscriptions
- ✅ Each subscription shows URL clearly
- ✅ List is empty initially or shows "No subscriptions" message
- ✅ List updates after each subscription is added
- ✅ List maintains order: subscription 1, subscription 2, subscription 3 (as added)
- ✅ Page refresh within session shows same list (in-memory persistence)

### 4A: Backend Implementation - Get Subscriptions Endpoint

- [ ] T071 Implement `SubscriptionService.GetAllSubscriptions()` method: return List<Subscription> ordered by AddedAt ascending
- [ ] T072 Implement `SubscriptionsController.GetSubscriptions()` method: call SubscriptionService.GetAllSubscriptions(), return 200 OK with subscription list
- [ ] T073 Test manually via curl: `GET /api/subscriptions` (after adding subscriptions) - expect 200 + array of subscriptions in order
- [ ] T074 [US2] Test: Unit test `SubscriptionServiceTests.GetAllSubscriptions_AfterAdd_ReturnsList` verifies service returns subscriptions in order
- [ ] T075 [US2] Test: Unit test `SubscriptionsControllerTests.GetSubscriptions_ReturnsOkWithList` verifies controller returns 200 status

### 4B: Frontend Implementation - SubscriptionList Component

- [ ] T076 Create Blazor list component `SubscriptionList.razor` with `@foreach (var sub in Subscriptions)` loop
- [ ] T077 Display each subscription URL in component (simple `<div>` or `<li>` element)
- [ ] T078 Add "No subscriptions" message when list is empty
- [ ] T079 Implement `OnInitializedAsync()` in component to load subscriptions on page load via SubscriptionApiClient.GetSubscriptions()
- [ ] T080 Test manually: Reload page, verify existing subscriptions from session still display
- [ ] T081 [US2] Test: Unit test `SubscriptionListTests.OnInitialized_LoadsSubscriptionsFromApi` verifies component loads list on init

### 4C: Frontend-Backend Integration - Get Subscriptions Flow

- [ ] T082 Implement `SubscriptionApiClient.GetSubscriptions()` method: GET `{apiBaseUrl}/api/subscriptions`, return List<Subscription>
- [ ] T083 Test via Postman or curl: Add subscriptions, then GET list, verify all are returned in correct order
- [ ] T084 [US2] Test: Integration test `ApiTests.GetSubscriptions_AfterAdds_ReturnedInOrder` verifies end-to-end GET flow
- [ ] T085 [US2] Test: Integration test `ApiTests.MultipleSubscriptions_DisplayOrder_Correct` verifies insertion order preservation

### 4D: Frontend-Backend Integration - Add + Display Flow

- [ ] T086 Update `SubscriptionForm.HandleAddSubscription()` to refresh SubscriptionList after adding (notify parent component)
- [ ] T087 Update `Index.razor` to handle add event: call `subscriptionList.LoadSubscriptionsAsync()` after form submission
- [ ] T088 Test end-to-end: Add URL → list updates immediately within 1 second (SC-001 ✅)
- [ ] T089 [US2] Test: Integration test `ApiTests.AddThenDisplay_ShowsNewSubscriptionImmediately` verifies immediate UI update

### 4E: User Story 2 End-to-End (Manual Testing)

- [ ] T090 Start backend + frontend (from Phase 3 still running)
- [ ] T091 Open browser to http://localhost:5213
- [ ] T092 **Test Scenario 1**: Verify subscription list is empty or shows "No subscriptions" (SC-002 ✅)
- [ ] T093 **Test Scenario 2**: Add URL "https://devblogs.microsoft.com/dotnet/feed/"
- [ ] T094 Verify subscription appears in list within 1 second
- [ ] T095 **Test Scenario 3**: Add second URL "https://www.reddit.com/r/csharp/.rss"
- [ ] T096 Verify both subscriptions in list in order added (first, then second)
- [ ] T097 **Test Scenario 4**: Add third URL "https://another-feed.com/rss"
- [ ] T098 Verify all three subscriptions in list in correct order (1, 2, 3)
- [ ] T099 **Test Scenario 5**: Refresh page (F5)
- [ ] T100 Verify all three subscriptions still visible (session persistence, SC-003 ✅)
- [ ] T101 Verify no console errors during any operation

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Code quality, cross-platform verification, final validation

### 5A: Code Quality Gates

- [ ] T102 Run full test suite: `dotnet test RSSFeedReader.sln` - verify all tests pass (0 failures)
- [ ] T103 Check for compiler warnings: `dotnet build --no-warnings-as-errors` - fix any warnings
- [ ] T104 Check for unused variables/imports: review all source files and remove dead code
- [ ] T105 Code review checklist: verify no persistence code (in-memory only), no feed fetching, no URL validation per spec
- [ ] T106 [P] Verify constitution compliance: confirm Principles I-VI met (MVP-First, Clean Arch, Security, Quality, Cross-Platform, Documentation)

### 5B: Cross-Platform Build Verification

- [ ] T107 [P] [Windows] Run `dotnet build RSSFeedReader.sln --configuration Release` on Windows 10/11 - expect 0 warnings, 0 errors (SC-004 ✅)
- [ ] T108 [P] [macOS] Run `dotnet build RSSFeedReader.sln --configuration Release` on macOS 12+ - expect 0 warnings, 0 errors
- [ ] T109 [P] [Linux] Run `dotnet build RSSFeedReader.sln --configuration Release` on Ubuntu 20.04+ - expect 0 warnings, 0 errors

### 5C: Local Development Checklist

- [ ] T110 Verify checklist items from ProjectGoals.md: Backend runs, frontend loads, CORS works, no console errors
- [ ] T111 Verify all scripts in quickstart.md work as documented: build, run, test commands execute successfully

### 5D: Documentation Finalization

- [ ] T112 Update README.md with "MVP Complete" section summarizing deliverables
- [ ] T113 Update README.md with known limitations (in-memory only, no persistence, no feed fetching)
- [ ] T114 Add troubleshooting section to README.md for common issues (port conflicts, CORS errors, etc.)
- [ ] T115 Verify all internal links in documentation work (README → spec → contracts → data-model → quickstart)

### 5E: Final Validation

- [ ] T116 End-to-end test: Start backend + frontend fresh, add 5 subscriptions, verify all display in order, page refresh confirms persistence
- [ ] T117 Verify SC-001: Add URL and verify display within 1 second timing
- [ ] T118 Verify SC-002: Subscription list displays all URLs clearly (no truncation/corruption)
- [ ] T119 Verify SC-003: Add multiple subscriptions without data loss
- [ ] T120 Verify SC-004: Application runs on Windows, macOS, Linux without errors
- [ ] T121 Verify SC-005: All endpoints (POST/GET) return correct data via curl + UI
- [ ] T122 Verify SC-006: Frontend loads without console errors, DevTools verified
- [ ] T123 Verify SC-007: Code review confirms MVP principles (no persistence, no fetching, no validation)

---

## Task Summary

| Phase | Purpose | Task Count | Dependencies |
|-------|---------|-----------|--------------|
| **Phase 1** | Project Setup | T001-T009 (9 tasks) | None |
| **Phase 2** | Foundational | T010-T044 (35 tasks) | Phase 1 complete |
| **Phase 3** | User Story 1: Add Subscription | T045-T070 (26 tasks) | Phase 2 complete |
| **Phase 4** | User Story 2: Display List | T071-T101 (31 tasks) | Phase 2 complete (can run parallel with Phase 3) |
| **Phase 5** | Polish & Validation | T102-T123 (22 tasks) | Phase 3 + 4 complete |
| **TOTAL** | **All Phases** | **123 tasks** | Sequential phases; T3 & T4 parallelizable |

---

## Parallel Execution Opportunities

**Phase 1 (Setup)**: All project creation tasks [P] parallelizable
- Create backend + frontend + test projects simultaneously

**Phase 2 (Foundational)**: Significant parallelization possible
- **2A (Backend)** and **2B (Frontend)** can run in parallel (separate teams/dev)
- **2C (Testing)**, **2D (Docs)**, **2E (Cross-Platform)** parallelizable after 2A+2B start

**Phase 3 & 4 (User Stories)**:
- Both P1 stories can run in parallel after Phase 2 complete
- Frontend team (T051-T089) and backend team (T045-T085) can work independently
- Integration tasks at end (T086-T101) must sync both

**Recommended Development Flow**:

```
Team A: Backend           Team B: Frontend        Team C: Docs
├─ T010-T019             ├─ T020-T031            ├─ T039-T041
├─ T045-T050 (US1)       ├─ T051-T065 (US1)      ├─ T115
├─ T071-T075 (US2)       ├─ T076-T092 (US2)      └─ T123 (final)
├─ T102                  ├─ T102
├─ T107                  ├─ T108-T109
└─ T121                  └─ T122
```

---

## Implementation Strategy

**MVP-First Approach**:
1. **Phase 1 & 2** establish all infrastructure (no delays here - gate must pass)
2. **Phase 3 & 4** implement subscription management in parallel (both are P1, independent teams possible)
3. **Phase 5** validates completeness (all tests pass, cross-platform verified, docs current)

**Test-Driven Approach**:
- Each user story includes unit + integration tests
- Tests are listed alongside implementation (implement feature, then write test to verify)
- Final phase runs complete test suite to confirm all implementations correct

**Definition of Done** (for each user story):
- ✅ All tasks in phase complete
- ✅ All tests pass (unit + integration)
- ✅ Manual testing verifies acceptance scenarios
- ✅ Code review confirms constitution compliance
- ✅ No compiler warnings
- ✅ Documentation updated

**Release Criteria** (Phase 5 complete):
- ✅ MVP working on Windows, macOS, Linux
- ✅ User can add subscriptions and view them (both user stories)
- ✅ All success criteria met (SC-001 through SC-007)
- ✅ Code ready for merge to main branch
- ✅ Ready for Extended-MVP planning
