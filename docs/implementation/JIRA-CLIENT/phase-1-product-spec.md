# PRD - Phase 1

## 1. Module Overview

- **Purpose:** Provide a secure, resilient Jira API client to fetch Epics, Stories, Bugs, and Tasks with correct release membership mapping.
- **Business Value:** Ensures trustworthy data ingestion for HALDI, enabling accurate hierarchy, progress, and signals downstream.
- **User Value:** Indirect—users receive reliable, current release data powering the UI and reports.
- **Module Type:** Core (Foundation)
- **Phase 1 Scope:** Authentication (API token/OAuth), pagination, rate-limit backoff, normalized payloads, fixVersion/labels mapping, error handling.

## 2. Scope & Boundaries

- **In Scope:**
    - Secure auth configuration (API token or OAuth) and secret management.
    - Fetch endpoints: search (JQL), issue detail, versions, changelog, priority taxonomy.
    - Pagination (`maxResults`, `startAt`) and accumulation for large datasets.
    - Rate-limit handling with exponential backoff and retries for transient errors.
    - Normalization/mapping of payloads to HALDI domain (Release, Epic, Story, Bug, Task).
    - Release membership detection via `fixVersion` and fallback labels.
    - Structured error surfaces with actionable messages.
- **Out of Scope:**
    - Database persistence or scheduler jobs (DATA-LAYER).
    - Public app APIs for UI (APP-APIS).
    - Complex forecasting or calculations (delays/timeline shift beyond basic fields).
- **Dependencies:**
    - Jira Cloud API v3 availability and credentials.
    - Network connectivity and adherence to Jira rate limits.
- **Dependents:**
    - DATA-LAYER (ingestion pipeline uses this client).
    - APP-APIS (reads persisted outputs shaped by this client’s normalization).

## 3. User Personas & Contexts

- **Persona:** Backend Developer / Platform Engineer
- **Goals:** Fetch clean, complete data from Jira reliably to power HALDI.
- **Context:** Early MVP; establishing robust patterns for later ingestion and APIs.
- **Pain Points:** Rate limits, inconsistent fields, pagination complexity, error handling.

## 4. User Stories

- **US-JIRA-CLIENT-001:** As an engineer, I want authenticated Jira access so that I can fetch issues securely.
  - **Priority:** High
  - **Acceptance Criteria:**
    - Given configured credentials, when I call Jira API, then auth succeeds and is audited.
    - Given invalid credentials, when I call, then I get clear errors without exposing secrets.
- **US-JIRA-CLIENT-002:** As an engineer, I want pagination handling so that I can fetch complete datasets for releases.
  - **Priority:** High
  - **Acceptance Criteria:**
    - Given large result sets, when fetching, then results accumulate until total is reached.
    - Given rate limits mid-fetch, when retrying, then backoff applies without data loss.
- **US-JIRA-CLIENT-003:** As an engineer, I want normalized payloads so that downstream modules can rely on consistent fields.
  - **Priority:** High
  - **Acceptance Criteria:**
    - Given Jira responses, when normalized, then entities map to Release/Epic/Story/Bug/Task shapes with keys and associations.
- **US-JIRA-CLIENT-004:** As an engineer, I want release membership mapping so that items are correctly tied to selected releases.
  - **Priority:** Medium
  - **Acceptance Criteria:**
    - Given items with `fixVersion` or labels, when mapped, then membership is correctly flagged; missing fields handled via fallbacks.

## 5. Functional Requirements

- **FR-JIRA-CLIENT-001:** Authenticate with Jira API using configured method (API token or OAuth) and store secrets securely.
  - **Related Project FR:** FR-001.
  - **Module Context:** Foundation for all data access.
- **FR-JIRA-CLIENT-002:** Implement JQL search to retrieve Epics/Stories/Bugs/Tasks by release membership.
  - **Related Project FR:** FR-002, FR-003.
  - **Module Context:** Enables hierarchy construction.
- **FR-JIRA-CLIENT-003:** Support pagination and rate-limit backoff with bounded retries.
  - **Related Project FR:** Non-functional performance/reliability.
  - **Module Context:** Ensures complete and stable fetches.
- **FR-JIRA-CLIENT-004:** Normalize responses to HALDI entity shapes with essential fields and relationships.
  - **Related Project FR:** Data Models & Entities (placeholder now, define via samples).
  - **Module Context:** Downstream compatibility.
- **FR-JIRA-CLIENT-005:** Map release membership via `fixVersion` and fallback to labels when absent.
  - **Related Project FR:** Rule 5.
  - **Module Context:** Accurate scoping of items.
- **FR-JIRA-CLIENT-006:** Provide structured error handling and descriptive messages for API/network failures.
  - **Related Project FR:** FR-015.
  - **Module Context:** Developer diagnostics and resilience.

## 6. Business Rules & Logic

- **BR-JIRA-CLIENT-001:** Respect Jira rate limits—throttle requests and backoff exponentially.
  - **Example:** Retry up to 3 times with jittered delays on 429/5xx.
  - **Edge Cases:** Hard-stop on persistent 4xx credentials errors.
- **BR-JIRA-CLIENT-002:** Idempotent fetch behavior—avoid duplicate records within a single fetch cycle.
  - **Example:** Track `startAt` and item keys to prevent duplication.
  - **Edge Cases:** Resume safely after partial failures.
- **BR-JIRA-CLIENT-003:** Normalize custom fields (e.g., Epic Link) via project-specific configuration.
  - **Example:** Map Epic Link custom field ID to standard association.
  - **Edge Cases:** If unknown, flag for manual mapping.

## 7. User Interface Requirements

- None (module is headless). Optional: developer CLI or logs to inspect responses.

## 8. Data Requirements

- **Input Data:** Jira issues, versions, priorities via REST API v3.
- **Output Data:** Normalized entities (Release/Epic/Story/Bug/Task) passed to ingestion layer.
- **Stored Data:** None in this module; persistence handled by DATA-LAYER.

## 9. Integration Specifications

- **APIs/Interfaces:** Jira REST v3: `/search`, `/issue/{id}`, `/project/{id}/versions`, `/issue/{id}/changelog`, `/priority`.
- **Events:** None.
- **Data Flow:** External → Client → Normalized outputs (to ingestion).
- **Error Handling:** Retry/backoff, structured errors, audit logs for calls (timestamps, counts, statuses).

## 10. Performance & Quality Requirements

- **Performance:** Typical release queries return in ≤ 10 seconds; pagination completes within acceptable windows.
- **Reliability:** Retries on transient errors; clear failures on auth/permission issues.
- **Security:** Secrets stored securely; responses sanitized in logs.
- **Usability:** Developer diagnostics sufficient to troubleshoot (counts, timings, error details).

## 11. Success Metrics

- **Business Metrics:** ≥95% correct release mapping; ≥90% hierarchical completeness downstream.
- **User Metrics:** Time-to-first data for MVP ≤ 1 hour setup.
- **Technical Metrics:** ≤ 1% error rate on fetches; ≤ 3 retries per batch; audited logs per run.

## 12. Edge Cases & Error Scenarios

- **Error Case 1:** Invalid credentials or expired token.
  - **User Experience:** Clear error; setup guidance.
  - **System Behavior:** Abort without retries; redact secrets.
- **Edge Case 1:** Inconsistent status history or missing fields.
  - **Business Logic:** Flag items for manual review; continue fetch.
  - **User Impact:** Downstream modules handle markers ("Needs Review").

## 13. Future Considerations

- **Enhancement 1:** Add caching to reduce rate-limit pressure.
- **Enhancement 2:** Support additional platforms beyond Jira via adapters.
- **Enhancement 3:** CLI for dry-run sampling and schema inference.

## 14. Acceptance Criteria Summary

- [ ] Auth configured and verified; secrets stored securely.
- [ ] JQL fetches retrieve Epics/Stories/Bugs/Tasks with pagination.
- [ ] Rate-limit backoff and retries implemented with audit logs.
- [ ] Normalized outputs for entities and release membership mapping.
- [ ] Structured error handling with descriptive messages.

## 15. Open Questions

- **Question 1:** Which auth method (API token vs OAuth) will be standard for environments?
- **Question 2:** What is the custom field ID for Epic Link in target Jira projects?
