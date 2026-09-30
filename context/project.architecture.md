# Athlete Performance Tracker - Project Architecture

## 1. Architecture overview

The system uses an offline-first, event-driven flow: the Wear OS client records a completed session locally, synchronizes it when a phone or direct network path is available, stores it in database, and makes it available to the Flutter dashboard for post-session review and analytics.

```text
Wear OS watch
  session capture: heart rate, duration, steps, calories
           |
           v
Local watch database
  durable session record and sync queue
           |
   +-------+--------+
   |                |
   v                v
Paired phone     Watch Wi-Fi/LTE
Bluetooth path   direct network path
   |                |
   +-------+--------+
           v
Firebase backend
  Auth, Firestore, server-side processing
           |
           v
Flutter dashboard
  player history, coach analytics, exports, notifications
```

## 2. Components

| Layer        | Technology                                            | Responsibility |
| ---          | ---                                                   | ---            |
| Watch client | Flutter targeting Wear OS; health/workout integration | Start/end sessions; read available health metrics; create local records; coordinate sync |
| Watch persistence | Isar, Hive, or sqflite | Store completed sessions and synchronization state until acknowledged by the backend |
| Dashboard | Flutter for phone and desktop | Role-gated player and coach views; history; charts; exports |
| Identity and authorization | Firebase Authentication plus Firestore security rules | Sign-in, player/coach roles, team-scoped access control |
| Cloud data | Cloud Firestore | Session, player, team, analytics, and notification-preference storage |
| Backend automation | Firebase Cloud Functions | Validate uploads, maintain aggregates, run rules, initiate notifications or report work |
| Analytics UI | `fl_chart` | Heart-rate zones, trends, and group/individual visualizations |
| Reporting | Flutter `pdf` and `printing` packages | PDF generation and CSV export from dashboard data |
| Notifications | Firebase Cloud Messaging or equivalent Firebase-compatible service | Sync confirmation and weekly summary delivery |

## 3. Core data flow

1. The player starts a training or match session on the watch.
2. The watch collects available sensor-derived data during the session.
3. When the player ends the session, the client writes an immutable session record to local storage with `pending` synchronization status.
4. A sync worker detects a reachable route: companion phone over Bluetooth, or direct Wi-Fi/LTE.
5. The worker uploads the session with a stable client-generated ID so retries are idempotent.
6. Firestore accepts the record only if the authenticated player is authorized for its team and player identity.
7. A Cloud Function validates and normalizes the session, updates aggregates and trend inputs, evaluates rule-based flags, and records notification work where needed.
8. After the client receives a successful acknowledgement, it marks the local record `synced`. Failed records remain queued with retry metadata.
9. The dashboard reads authorized Firestore data to show player history, coach team analytics, and exports.

## 4. Suggested domain model

### Firestore collections

```text
users/{userId}
teams/{teamId}
teams/{teamId}/members/{userId}
sessions/{sessionId}
players/{playerId}/sessionSummaries/{sessionId}
teams/{teamId}/analytics/{periodId}
teams/{teamId}/alerts/{alertId}
reports/{reportId}
```

### Session document

```json
{
  "id": "client-generated-uuid",
  "teamId": "team-id",
  "playerId": "player-id",
  "type": "training",
  "startedAt": "timestamp",
  "endedAt": "timestamp",
  "durationSeconds": 0,
  "heartRate": {
    "averageBpm": 0,
    "maxBpm": 0,
    "samples": []
  },
  "steps": 0,
  "calories": 0,
  "distanceMeters": 0,
  "speed": {},
  "acceleration": {},
  "source": { "device": "wear-os", "appVersion": "" },
  "createdAt": "timestamp",
  "uploadedAt": "timestamp",
  "processingStatus": "complete"
}
```

Large, high-frequency heart-rate samples should be assessed against Firestore document limits and cost. For the first release, store summary metrics and zones in Firestore; place raw time-series samples in a separate compact store or object storage only when analysis requires them.

### Alert document

```json
{
  "id": "alert-id",
  "teamId": "team-id",
  "playerId": "player-id",
  "sessionId": "session-id",
  "rule": "workload-spike",
  "severity": "review",
  "message": "Recent workload differs materially from the player's baseline.",
  "createdAt": "timestamp",
  "acknowledgedBy": null
}
```

## 5. Client architecture

Use feature-oriented modules with a shared domain layer.

```text
lib/
  app/                 routing, theme, dependency setup
  core/                errors, connectivity, logging, utilities
  auth/                sign-in and role resolution
  sessions/            capture, local repository, sync queue
  analytics/           calculations, aggregates, charts
  dashboard/           coach and player presentation features
  reports/             PDF and CSV export
  notifications/       permission and message handling
```

The watch and dashboard can share domain entities, validation rules, and Firebase abstractions, while keeping Wear OS sensor code isolated from desktop/phone presentation code.

## 6. Offline synchronization design

- Persist the session before initiating any network request.
- Model local records with `pending`, `uploading`, `synced`, and `failed` states, plus retry count and last error.
- Use exponential backoff for retries and a manual retry action.
- Use the client-generated session ID as the Firestore document ID or idempotency key.
- Treat the server acknowledgement, not a dispatched request, as proof of sync.
- Do not delete a local record until a successful acknowledgement has been durably recorded.
- When a paired phone is available, use it as a transport path; otherwise use direct watch networking when supported.

## 7. Analytics and rules

Analytics are post-session. The initial implementation should use transparent, configurable rules rather than opaque scoring models.

- Derive session summaries from duration, heart rate, steps, calories, and optional distance/location data.
- Compare current workload with a player's recent baseline and team context.
- Compute heart-rate-zone distribution and historical trends.
- Evaluate workload-spike, excessive-duration, and insufficient-recovery candidates only after their thresholds and formulas are validated.
- Keep rule configuration versioned so an alert can be traced to the formula and threshold used.
- Present alerts as coach-review signals, never as injury predictions or medical advice.

## 8. Security and privacy

- Require authenticated access for all application data.
- Maintain membership and roles in `teams/{teamId}/members/{userId}`.
- Enforce that players read only their own sessions; coaches read only sessions within their teams.
- Enforce access in Firestore security rules and Cloud Functions; UI hiding alone is insufficient.
- Minimize collected personal and health-related data, document retention practices, and obtain appropriate consent for minors or school teams.
- Audit exports because reports can contain sensitive player performance data.

## 9. Deployment and observability

- Use Firebase environments for development, testing, and production.
- Use emulator-based tests for Firestore rules and Cloud Functions.
- Record sync failures, rejected uploads, and rule-processing errors without logging raw sensitive measurements unnecessarily.
- Track operational measures such as sync success rate, queued-session age, processing latency, and notification delivery status.

## 10. Decisions required before implementation

- Choose the local database: Isar, Hive, or sqflite.
- Confirm the Wear OS sensor and workout package that supports the targeted device/OS versions.
- Define supported sports and the distinction between training and match sessions.
- Confirm whether location is collected and therefore whether speed/acceleration is in scope.
- Define workload, readiness, recovery, and alert formulas with a qualified domain expert.
- Define report content, notification consent, data retention, and team onboarding.

