# Quick-Start Guide: MVP RSS Reader

**Feature**: MVP RSS Reader  
**Version**: 1.0.0  
**Date**: 2026-04-09  
**Target Audience**: Developers setting up local development environment

## Prerequisites

Before starting, verify you have:

- **dotnet CLI 6.0 or later** – Run `dotnet --version` to check
- **Git** – For version control
- **Browser** – Modern browser with DevTools (F12)
- **Text Editor or IDE** – Visual Studio Code, Visual Studio, or similar
- **Terminal/Command Prompt** – Access to shell commands

## Project Setup

### Clone Repository

```bash
git clone https://github.com/kai-at-hallinc/spec-kit.git
cd spec-kit
git checkout 001-mvp-rss-reader  # Switch to feature branch
```

### Create Project Structure

The template generation (covered in Phase 2 Foundational) will create this structure:

```
RSSFeedReader/
├── backend/RSSFeedReader.Api/           # ASP.NET Core Web API
├── frontend/RSSFeedReader.UI/           # Blazor WebAssembly
└── solution files
```

### Restore Dependencies

```bash
# Restore all NuGet packages
dotnet restore

# Or individually:
cd backend/RSSFeedReader.Api && dotnet restore
cd ../frontend/RSSFeedReader.UI && dotnet restore
```

## Building the Application

### Full Build

```bash
# Build entire solution (backend + frontend)
dotnet build RSSFeedReader.sln

# Verify no compiler warnings or errors
# Output should end with: "Build succeeded"
```

### Platform-Specific Verify

```bash
# Windows with PowerShell
dotnet build --configuration Release
# Verify successful on Windows 10/11

# macOS
dotnet build --configuration Release
# Verify successful on macOS 12+

# Linux (Ubuntu/Debian)
dotnet build --configuration Release
# Verify successful on Ubuntu 20.04+
```

## Running the Application

### Terminal 1: Backend API

```bash
cd backend/RSSFeedReader.Api
dotnet run

# Expected output:
# info: Microsoft.Hosting.Lifetime[14]
#       Now listening on: http://localhost:5151
# info: Microsoft.Hosting.Lifetime[0]
#       Application started. Press Ctrl+C to exit.
```

**Verification**:
- Backend listens on `http://localhost:5151`
- No error messages in output
- No "OpenAPI/Swagger" warnings (not needed for MVP)

### Terminal 2: Frontend UI

```bash
cd frontend/RSSFeedReader.UI
dotnet run

# Expected output:
# info: Microsoft.Hosting.Lifetime[14]
#       Now listening on: http://localhost:5213
# info: Microsoft.Hosting.Lifetime[0]
#       Application started. Press Ctrl+C to exit.
```

**Verification**:
- Frontend listens on `http://localhost:5213`
- No compilation errors
- No "Failed to fetch" warnings yet

## Verification Checklist

Before testing the MVP feature, verify all components:

### 1. Backend Running

```bash
# In another terminal, test backend
curl -X GET http://localhost:5151/api/subscriptions

# Expected response:
# []
```

✅ **CHECK**: GET returns empty array → Backend running correctly

### 2. Frontend Loaded

1. Open browser: `http://localhost:5213`
2. Press `F12` to open DevTools → Console tab
3. Look for errors like:
   - ❌ `Failed to fetch from http://localhost:5151` → Backend not running
   - ❌ `CORS error` → CORS misconfiguration
   - ✅ No errors → Frontend loaded successfully

### 3. CORS Configuration

Check `backend/RSSFeedReader.Api/Program.cs`:

```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowLocalhost", policy =>
    {
        policy
            .WithOrigins("http://localhost:5213")
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

var app = builder.Build();
app.UseCors("AllowLocalhost");
```

✅ **CHECK**: CORS explicitly allows `http://localhost:5213` → Configuration correct

### 4. Frontend Configuration

Check `frontend/RSSFeedReader.UI/wwwroot/appsettings.json`:

```json
{
  "ApiBaseUrl": "http://localhost:5151"
}
```

And in `Program.cs`:

```csharp
var apiBaseUrl = builder.Configuration["ApiBaseUrl"];
builder.Services.AddScoped(sp => new HttpClient { BaseAddress = new Uri(apiBaseUrl) });
```

✅ **CHECK**: Frontend configured to call backend on port 5151 → Ready

## First Test: Add Subscription

### Manual Test via curl

```bash
# Add a subscription (use any valid RSS feed URL)
curl -X POST http://localhost:5151/api/subscriptions \
  -H "Content-Type: application/json" \
  -d '{"url":"https://devblogs.microsoft.com/dotnet/feed/"}'

# Expected response:
# {"url":"https://devblogs.microsoft.com/dotnet/feed/","addedAt":"2026-04-09T14:30:00Z"}

# Retrieve subscriptions
curl -X GET http://localhost:5151/api/subscriptions

# Expected response:
# [{"url":"https://devblogs.microsoft.com/dotnet/feed/","addedAt":"2026-04-09T14:30:00Z"}]
```

✅ **CHECK**: API returns correct subscription → Backend working

### UI Test

1. In browser at `http://localhost:5213`, look for:
   - Text input field (for URL)
   - "Add Subscription" button
   - Empty subscription list

2. Paste a feed URL into the input field:
   ```
   https://devblogs.microsoft.com/dotnet/feed/
   ```

3. Click "Add Subscription"

4. Verify:
   - ✅ Subscription appears in list within 1 second
   - ✅ Input field is cleared
   - ✅ No console errors in DevTools (F12)

5. Add a second subscription:
   ```
   https://www.reddit.com/r/csharp/.rss
   ```

6. Verify:
   - ✅ Both subscriptions in list in order added
   - ✅ No data loss from first subscription
   - ✅ Page refresh (F5) shows both subscriptions (still in memory during session)

✅ **CHECK**: MVP functionality working correctly → Ready for development

## Running Tests

### Unit Tests (Backend)

```bash
cd backend/RSSFeedReader.Api.Tests
dotnet test

# Expected output:
# Test Run Successful.
# Total tests: N, Passed: N, Failed: 0, Skipped: 0
```

### Integration Tests (Backend + Frontend)

```bash
cd integration/RSSFeedReader.Integration.Tests
dotnet test

# Expected output similar to unit tests
```

### Frontend Component Tests (Blazor)

```bash
cd frontend/RSSFeedReader.UI.Tests
dotnet test

# Expected output similar to unit tests
```

### All Tests

```bash
# Run entire test suite
dotnet test RSSFeedReader.sln

# Verify all pass with 0 failures
```

## Stopping the Application

### Stop Backend

In Terminal 1 (backend):
```
Press Ctrl+C
```

### Stop Frontend

In Terminal 2 (frontend):
```
Press Ctrl+C
```

Both should exit gracefully. Subscriptions in memory are lost (expected MVP behavior).

## Troubleshooting

### Issue: "Address already in use" (port 5151 or 5213)

**Cause**: Another app is already using the port

**Solution**:
```bash
# Find which process uses the port
lsof -i :5151              # macOS/Linux
netstat -ano | findstr :5151  # Windows

# Kill the process
kill -9 <PID>              # macOS/Linux
taskkill /PID <PID> /F     # Windows

# Restart the app
dotnet run
```

### Issue: "CORS error" in browser console

**Cause**: Backend CORS not configured or frontend URL not in allowlist

**Solution**:
1. Verify backend is running on port 5151
2. Check `Program.cs` CORS policy includes `http://localhost:5213`
3. Check frontend `appsettings.json` has correct `ApiBaseUrl`
4. Restart both apps

### Issue: "Failed to fetch" after clicking "Add"

**Cause**: Frontend cannot reach backend

**Solution**:
```bash
# Verify backend is running:
curl http://localhost:5151/api/subscriptions

# Verify ports:
# Backend should listen on 5151
# Frontend should listen on 5213

# Check browser console (F12):
# Look for specific error message
```

### Issue: Compiler errors during build

**Cause**: Missing dependencies or incorrect .NET version

**Solution**:
```bash
# Verify dotnet version
dotnet --version

# Restore packages
dotnet restore

# Clean and rebuild
dotnet clean
dotnet build
```

## Development Workflow

1. **Code changes**: Make edits in backend or frontend code
2. **Rebuild**: Press `Ctrl+C` to stop app, then `dotnet run` to restart
3. **Test manually**: Use browser or curl to test changes
4. **Run test suite**: `dotnet test RSSFeedReader.sln`
5. **Commit**: `git add . && git commit -m "message"`

## Next Steps

Once MVP is running and tested:

1. **Code Review**: Verify implementation matches spec and constitution
2. **Documentation**: Update README.md with setup instructions
3. **Merge**: Merge feature branch to main via pull request
4. **Extended-MVP**: Begin feed fetching and display phase

## Reference Documentation

- **Specification**: `../spec.md`
- **API Contract**: `../contracts/api-contract.md`
- **Data Model**: `../data-model.md`
- **Constitution**: `.specify/memory/constitution.md`
- **ASP.NET Core Docs**: https://docs.microsoft.com/aspnet/core
- **Blazor Docs**: https://docs.microsoft.com/aspnet/core/blazor
