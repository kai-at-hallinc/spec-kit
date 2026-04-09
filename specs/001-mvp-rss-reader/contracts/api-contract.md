# Backend API Contract

**Feature**: MVP RSS Reader  
**Version**: 1.0.0  
**Date**: 2026-04-09  
**Base URL**: `http://localhost:5151` (development)

## Overview

Backend exposes two REST API endpoints for subscription management: one to add subscriptions, one to retrieve the list. All communication is JSON. No authentication required for MVP.

## Endpoints

### 1. Add Subscription

**Endpoint**: `POST /api/subscriptions`

**Description**: Accept a feed URL from the frontend and store it in memory.

**Request**:

```http
POST /api/subscriptions HTTP/1.1
Host: localhost:5151
Content-Type: application/json

{
  "url": "https://devblogs.microsoft.com/dotnet/feed/"
}
```

**Request Schema**:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "url": {
      "type": "string",
      "description": "RSS/Atom feed URL. No validation applied in MVP."
    }
  },
  "required": ["url"]
}
```

**Response (201 Created)**:

```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "url": "https://devblogs.microsoft.com/dotnet/feed/",
  "addedAt": "2026-04-09T14:30:00Z"
}
```

**Response Schema**:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "url": {
      "type": "string",
      "description": "The feed URL as received"
    },
    "addedAt": {
      "type": "string",
      "format": "date-time",
      "description": "ISO 8601 UTC timestamp when subscription was created"
    }
  }
}
```

**Error Responses**:

| Status | Condition | Response Body |
|--------|-----------|----------------|
| 400 | Missing `url` field | `{ "error": "url field is required" }` |
| 400 | Empty `url` string | `{ "error": "url cannot be empty" }` |
| 500 | Server error | `{ "error": "Internal server error" }` |

**MVP Behavior**:

- Any non-empty URL string is accepted
- No RSS/Atom feed validation
- No URL format validation
- Duplicate URLs allowed
- Subscription stored immediately in memory
- Response returns exact URL as received

---

### 2. Get Subscriptions

**Endpoint**: `GET /api/subscriptions`

**Description**: Retrieve all subscriptions in order of addition.

**Request**:

```http
GET /api/subscriptions HTTP/1.1
Host: localhost:5151
Accept: application/json
```

**Request Parameters**: None

**Response (200 OK)**:

```http
HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "url": "https://devblogs.microsoft.com/dotnet/feed/",
    "addedAt": "2026-04-09T14:30:00Z"
  },
  {
    "url": "https://another-blog.com/rss",
    "addedAt": "2026-04-09T14:31:15Z"
  }
]
```

**Response Schema**:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "array",
  "items": {
    "type": "object",
    "properties": {
      "url": { "type": "string" },
      "addedAt": { "type": "string", "format": "date-time" }
    }
  }
}
```

**Error Responses**:

| Status | Condition | Response Body |
|--------|-----------|----------------|
| 500 | Server error | `{ "error": "Internal server error" }` |

**MVP Behavior**:

- Returns all subscriptions in order of addition (ascending AddedAt timestamp)
- Empty array `[]` if no subscriptions exist
- Never fails (no validation errors possible on GET)

---

## CORS Configuration

**MVP Configuration** (permissive for local development):

```
Access-Control-Allow-Origin: http://localhost:5213
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type
Access-Control-Max-Age: 3600
```

**Rationale**: Frontend runs on port 5213; backend runs on port 5151. Cross-origin requests require explicit CORS allowlist (browsers enforce same-origin policy). This minimal CORS allows localhost frontend to call backend API.

**Extended-MVP**: Will tighten CORS based on actual deployment topology.

---

## Error Handling

**MVP Error Strategy**: Simple, generic responses. No detailed error codes or messages.

```csharp
// Example backend error handling pattern
try
{
    var subscription = new Subscription { Url = url, AddedAt = DateTime.UtcNow };
    await _subscriptionService.AddSubscription(subscription);
    return CreatedAtAction(nameof(GetSubscriptions), subscription);
}
catch (Exception ex)
{
    return StatusCode(500, new { error = "Internal server error" });
}
```

**Frontend Error Handling** (from Blazor HttpClient):

```csharp
try
{
    var response = await _httpClient.PostAsJsonAsync("/api/subscriptions", new { url = inputUrl });
    if (response.IsSuccessStatusCode)
    {
        // Refresh list
        await LoadSubscriptions();
    }
    else
    {
        ErrorMessage = "Failed to add subscription";
    }
}
catch (Exception)
{
    ErrorMessage = "Failed to add subscription";
}
```

**Deferred to Extended-MVP**: Detailed error messages, specific error codes, retry logic, request logging.

---

## Example Usage Flow

### Add Subscription + Retrieve List

**Step 1**: Frontend user enters URL and clicks "Add"

```javascript
POST /api/subscriptions
{ "url": "https://example.com/feed.xml" }
```

**Step 2**: Backend responds with created subscription

```json
{
  "url": "https://example.com/feed.xml",
  "addedAt": "2026-04-09T14:30:00Z"
}
```

**Step 3**: Frontend immediately requests full list

```javascript
GET /api/subscriptions
```

**Step 4**: Backend returns list with new entry

```json
[
  {
    "url": "https://example.com/feed.xml",
    "addedAt": "2026-04-09T14:30:00Z"
  }
]
```

**Step 5**: Frontend updates UI with new subscription displayed

---

## Future API Extensions (Extended-MVP)

These endpoints will be added without breaking existing MVP contracts:

- `DELETE /api/subscriptions/{url}` – Remove subscription
- `POST /api/subscriptions/{url}/refresh` – Manually fetch feed items
- `GET /api/subscriptions/{url}/items` – Retrieve feed items
- `PATCH /api/subscriptions/{url}` – Update subscription metadata

**Design Principle**: MVP API remains stable; new features extend, not replace, existing endpoints.

---

## Testing Contract

From `integration/ApiTests.cs`:

```csharp
[Test]
public async Task AddSubscription_ValidUrl_Returns201AndSubscription()
{
    var newSubscription = new { url = "https://example.com/feed.xml" };
    var response = await _client.PostAsJsonAsync("/api/subscriptions", newSubscription);
    
    Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);
    var created = await response.Content.ReadAsAsync<Subscription>();
    Assert.AreEqual("https://example.com/feed.xml", created.Url);
}

[Test]
public async Task GetSubscriptions_AfterAdd_ReturnsListWithNewEntry()
{
    await _client.PostAsJsonAsync("/api/subscriptions", new { url = "https://example.com/feed.xml" });
    var response = await _client.GetAsync("/api/subscriptions");
    
    Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
    var subscriptions = await response.Content.ReadAsAsync<List<Subscription>>();
    Assert.AreEqual(1, subscriptions.Count);
}
```

---

## Notes

- No rate limiting in MVP
- No request body size limits documented (deferred to Extended-MVP)
- All timestamps use UTC (ISO 8601 format for JSON compatibility)
- No API versioning in MVP (assume single version); Extended-MVP may add `/v2/` paths
- No request/response logging required for MVP; can be added later without breaking contract
