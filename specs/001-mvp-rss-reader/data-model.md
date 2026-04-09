# Data Model: MVP RSS Reader

**Feature**: MVP RSS Reader  
**Version**: 1.0.0  
**Date**: 2026-04-09

## Overview

MVP data model focuses on minimal scope: subscription management only. A single entity (`Subscription`) represents an RSS/Atom feed URL added by the user.

## Entities

### Subscription

**Purpose**: Represents a single RSS/Atom feed subscription managed by the user.

**Attributes**:

| Attribute | Type | Required | Validation | Notes |
|-----------|------|----------|-----------|-------|
| `Url` | string | Yes | None (MVP accepts any string) | Feed URL provided by user. No URL format validation in MVP. |
| `AddedAt` | DateTime | Yes | Timestamp only | When the subscription was added. Implicit ordering key for UI display. |

**Constraints**:

- `Url` is never null or empty (enforced by C# model)
- `AddedAt` is set to current UTC time when subscription is created
- No uniqueness constraint (duplicate URLs allowed per spec)
- No persistence (in-memory only; lost on app restart)

**Relationships**: None (MVP has only one entity type)

**State Transitions**: 
- New subscription created in memory when user submits URL
- Subscription persists in memory until application restarts
- No removal, no modification, no status tracking (Extended-MVP features)

**Validation Rules** (MVP):

- ✓ Accept any URL string (no format validation)
- ✓ Accept duplicate URLs
- ✓ Preserve insertion order
- ✗ No feed validation (Extended-MVP)
- ✗ No URL reachability check (Extended-MVP)

## C# Model Implementation

```csharp
namespace RSSFeedReader.Api.Models
{
    public class Subscription
    {
        /// <summary>
        /// RSS/Atom feed URL provided by user. No validation applied in MVP.
        /// </summary>
        public string Url { get; set; }

        /// <summary>
        /// UTC timestamp when subscription was added. Used for UI ordering.
        /// </summary>
        public DateTime AddedAt { get; set; }
    }
}
```

## Storage

**MVP Approach**: In-memory `List<Subscription>` in `SubscriptionService`.

```csharp
namespace RSSFeedReader.Api.Services
{
    public class SubscriptionService
    {
        private static readonly List<Subscription> _subscriptions = new();

        public void AddSubscription(string url)
        {
            var subscription = new Subscription
            {
                Url = url,
                AddedAt = DateTime.UtcNow
            };
            _subscriptions.Add(subscription);
        }

        public IEnumerable<Subscription> GetAllSubscriptions()
        {
            return _subscriptions.OrderBy(s => s.AddedAt).ToList();
        }
    }
}
```

**Lifecycle**:
- Subscription created: User submits URL via frontend form → Backend creates Subscription object → Stored in `_subscriptions` List
- Subscription retrieved: Frontend calls GET /api/subscriptions → Backend returns `_subscriptions` ordered by AddedAt
- Subscription lost: Application restarts → `_subscriptions` static field is re-initialized to empty List

**Thread Safety**: 
MVP runs on single development machine; thread-safety optimizations deferred to Extended-MVP if needed for background operations.

## Frontend Data Binding

Blazor component binds to `List<Subscription>` returned from API:

```csharp
// SubscriptionList.razor.cs
public List<Subscription> Subscriptions { get; set; } = new();

protected override async Task OnInitializedAsync()
{
    Subscriptions = await ApiClient.GetSubscriptions();
}

// After AddSubscription button clicked:
await ApiClient.AddSubscription(inputUrl);
Subscriptions = await ApiClient.GetSubscriptions(); // Refresh list
```

## Extended-MVP Considerations

Future phases will extend this model:

- **Persistence**: Add database entity mapping (EF Core + SQLite)
  - Add `int Id` primary key
  - Add relationships to `FeedItem` entity
  - Add `LastRefreshedAt` timestamp

- **Feed Operations**:
  - Add `FeedTitle`, `FeedDescription` (parsed from feed)
  - Add `IsActive` boolean (for soft deletion)
  - Add `LastError` string (for error tracking)

- **Advanced Features**:
  - Add `Notes` field (user-provided annotation)
  - Add `Category` (for organization)
  - Add `UpdateFrequency` (polling interval)

**Design Principle**: MVP model intentionally minimal; Extended-MVP adds fields without breaking existing API contract.

## Notes

- No database migration strategy needed for MVP (in-memory only)
- No ORM required (direct List manipulation in MVP)
- C# model serves dual purpose: backend storage + JSON serialization for API responses
- Frontend uses same Subscription class structure (via HttpClient JSON deserialization)
