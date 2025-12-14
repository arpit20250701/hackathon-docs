# PRD - Phase 1

## 1. Module Overview

- **Purpose:** Persist normalized Jira data into HALDI’s database via an idempotent ingestion pipeline with auditability.
- **Business Value:** Provides reliable, queryable data to power hierarchy views, KPIs, and signals with minimal manual effort.
- **User Value:** Indirect—users experience fast, consistent UI backed by correct data.
- **Module Type:** Core
- **Phase 1 Scope:** Minimal schemas (Release, Epic, Story, Bug, Task), idempotent upserts, ingestion jobs with audit logs, retries/backoff, basic integrity checks for release membership.

## 2. Scope & Boundaries

- **In Scope:**
    - Define DB schemas and indexes for Release/Epic/Story/Bug/Task with associations.
    - Implement ingestion job(s) that consume normalized outputs from JIRA-CLIENT.
    - Idempotent upsert behavior using item keys and timestamps.
    - Audit logs per run: run ID, start/end, counts, successes/failures.
    - Retry with exponential backoff on transient source errors.
    - Integrity checks: validate Epic → Story links, release membership flags.
- **Out of Scope:**
    - Public API endpoints (APP-APIS) for UI consumption.
    - Advanced analytics or forecasting.
    - Report generation.
- **Dependencies:**
    - JIRA-CLIENT normalized payloads.
    - Database environment available (dev/test).
- **Dependents:**
    - APP-APIS reads these persisted entities.
    - USER-INTERFACE relies on APP-APIS fed by this data.

## 3. User Personas & Contexts

- **Persona:** Backend Engineer / Data Engineer
- **Goals:** Persist clean data reliably and audit ingestion runs.
- **Context:** MVP foundation; correctness and traceability prioritized.
- **Pain Points:** Duplicates, inconsistent associations, partial failures.

## 4. User Stories

- **US-DATA-LAYER-001:** As an engineer, I want idempotent upserts so that repeated ingestion does not create duplicates.
  - **Priority:** High
  - **Acceptance Criteria:**
    - Given repeated runs, when upserting, then entity counts remain consistent and duplicates are prevented via keys.
- **US-DATA-LAYER-002:** As an engineer, I want audit logs so that I can track ingestion outcomes.
  - **Priority:** High
  - **Acceptance Criteria:**
    - Given a run, when completed, then logs include run ID, start/end, counts, failures with reasons.
- **US-DATA-LAYER-003:** As an engineer, I want basic integrity checks so that associations and release membership are trustworthy.
  - **Priority:** Medium
  - **Acceptance Criteria:**
    - Given ingested data, when validating, then Epic → Story links and release flags are verified; anomalies flagged.

## 5. Functional Requirements

- **FR-DATA-LAYER-001:** Define schemas for Release/Epic/Story/Bug/Task with fields: keys, summary, status, types, associations, fixVersion/labels.
  - **Related Project FR:** FR-018.
  - **Module Context:** Storage foundation.
- **FR-DATA-LAYER-002:** Implement idempotent upsert ingestion using keys and `updated` timestamps.
  - **Related Project FR:** FR-018 AC2.
  - **Module Context:** Prevent duplication and ensure freshness.
- **FR-DATA-LAYER-003:** Add retries with exponential backoff for transient source/client errors.
  - **Related Project FR:** FR-018 AC3.
  - **Module Context:** Resilience.
- **FR-DATA-LAYER-004:** Write audit logs per run with run ID, timings, item counts, successes/failures.
  - **Related Project FR:** FR-018 AC4.
  - **Module Context:** Observability.
- **FR-DATA-LAYER-005:** Respect rate limits and paginate source data without exceeding quotas.
  - **Related Project FR:** FR-018 AC5.
  - **Module Context:** Compliance.

## 6. Business Rules & Logic

- **BR-DATA-LAYER-001:** Upserts must be atomic per batch to avoid partial writes.
  - **Example:** Use transactions per batch; rollback on failures.
  - **Edge Cases:** Split batches if exceeding transaction limits.
- **BR-DATA-LAYER-002:** Associations must maintain referential integrity.
  - **Example:** Stories reference parent Epics; orphan handling flagged.
  - **Edge Cases:** Temporarily store unlinked items for later resolution.
- **BR-DATA-LAYER-003:** Release membership is determined primarily by `fixVersion`, falling back to labels.
  - **Example:** Multiple versions mapped; choose active target per run context.
  - **Edge Cases:** Missing fields tracked as anomalies.

## 7. User Interface Requirements

- None (headless). Optional admin console/log viewer in future.

## 8. Data Requirements

- **Input Data:** Normalized entities from JIRA-CLIENT.
- **Output Data:** Persisted entities and associations suitable for APP-APIS.
- **Stored Data:** Release/Epic/Story/Bug/Task, ingestion audit logs.
  - **Lifecycle:** Retain audit logs for ≥ 30 days; entities updated per run.

## 9. Integration Specifications

- **APIs/Interfaces:** Ingestion service consumes client outputs; DB connections.
- **Events:** None in Phase 1.
- **Data Flow:** Client → Ingestion → DB.
- **Error Handling:** Retries/backoff, transactional rollbacks, anomaly flags.

## 10. Performance & Quality Requirements

- **Performance:** Ingest typical releases in ≤ 5 minutes; batch sizes tuned.
- **Reliability:** Idempotent; recoverable after partial failures; consistent counts.
- **Security:** DB credentials stored securely; logs redact sensitive data.
- **Usability:** Clear audit logs and counters for run introspection.

## 11. Success Metrics

- **Business Metrics:** ≥95% release mapping accuracy reflected in DB.
- **User Metrics:** UI loads data consistently with minimal anomalies.
- **Technical Metrics:** Zero duplicate entities; ≤ 1% ingestion error rate; audit logs for 100% runs.

## 12. Edge Cases & Error Scenarios

- **Error Case 1:** Source client transient failures mid-batch.
  - **User Experience:** N/A.
  - **System Behavior:** Retry and resume; log partial progress.
- **Edge Case 1:** Inconsistent Epic → Story linkages.
  - **Business Logic:** Flag and store in anomaly table for PM review pathways.
  - **User Impact:** UI later shows "Needs Review" markers via APP-APIS.

## 13. Future Considerations

- **Enhancement 1:** Differential ingestion based on changelog snapshots.
- **Enhancement 2:** Admin dashboard for run monitoring and anomaly triage.
- **Enhancement 3:** Data retention policies for historical analytics.

## 14. Acceptance Criteria Summary

- [ ] Schemas created with keys, associations, and indexes.
- [ ] Idempotent upsert ingestion implemented.
- [ ] Audit logs per run captured and queryable.
- [ ] Retries/backoff and transactional integrity enforced.
- [ ] Integrity checks flag anomalies (links/membership).

## 15. Open Questions

- **Question 1:** Which database (Postgres, MongoDB, etc.) and schema conventions will be standard?
- **Question 2:** What retention period and detail level for ingestion audit logs?
