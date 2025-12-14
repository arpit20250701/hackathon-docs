# Vision

## 🚀 1. Vision Statement
HALDI delivers a single, trustworthy hierarchical release view that unifies Epics and Stories per release, makes progress and remaining scope obvious, surfaces open bugs and tasks by priority, and flags delays with indicative timeline impact — enabling managers to spot risks early, align stakeholders, and publish clear, consistent release updates with near‑zero manual effort.

## 👤 2. Target Users / Personas
- Project Managers: Own release tracking, need clear hierarchical visibility and publishable progress.
- Delivery/Engineering Managers: Ensure sprint-to-release alignment, need signals on delays, bugs, and workload.
- Product Owners/Product Managers (Secondary): Define release scope and priorities; consume clarity on progress and risks.
- Leadership Stakeholders (Secondary): Require concise, consistent release updates to make decisions.

## 🧩 3. Problem Statements
- Fragmented Visibility: Epics/Stories span multiple releases; no single hierarchical view per release leads to manual, error-prone reporting.
- Hidden Quality/Workload Signals: Open bugs and tasks linked to Stories aren’t visible in release progress views, obscuring risk and capacity.
- Delay Blind Spots: Delays tracked informally; timeline shift impacts aren’t surfaced early, causing downstream planning issues.
- Manual Publishing Overhead: Release updates require ad-hoc consolidation into decks/emails, reducing consistency and speed.

Risks & challenges:
- Data reliability: Inconsistent use of fixVersion/labels may affect release membership accuracy.
- Adoption: Teams must link Stories to Epics and keep statuses current for meaningful insights.
- Technical constraints: Phase 1 avoids complex forecasting; timeline shift remains indicative, not predictive.

## 🌟 4. Core Features / Capabilities
- Hierarchical Release View (Primary): Epic → Story structure targeted to a release, even when items span releases.
- Progress Signals (Primary): Status and counts at Epic and Story levels; completion vs. remaining scope.
- Quality & Workload Signals (Primary): Open Bugs by priority and open Tasks per Story with statuses.
- Delay Highlighting (Primary): Flag delayed Stories and infer indicative timeline shift for remaining work.
- Report Publishing (Secondary): Generate/export/share a clear release progress report with minimal manual effort.

## 🎯 5. Business Goals / Success Metrics
- Release Coverage: ≥ 95% Epics/Stories correctly mapped to selected release.
- Hierarchical Completeness: ≥ 90% Epics with fully linked Stories visible in release view.
- Progress Accuracy (Phase 1): ≥ 95% validation via manual PM confirmation.
- Quality Signal Visibility: 100% visibility of open bugs by priority; flag SLA breach for P1 bugs.
- Workload Signal Visibility: 100% visibility of open tasks per Story by status.
- Delay Detection: ≥ 90% of delayed Stories correctly flagged with indicative impact.
- Report Efficiency: ≤ 5 minutes to generate/share a release report.
- Manual Reduction: ≥ 80% reduction in manual consolidation vs. baseline.
- Adoption: ≥ 70% weekly active PM/DM users generating reports within 6 weeks.

## 🔭 6. Scope & Boundaries
In Scope (MVP):
- Hierarchical release view (Epics → Stories), progress states, bugs/tasks visibility.
- Delay highlighting with indicative timeline shift (simple heuristics; no complex forecasting).
- Report publishing/export (PDF/Markdown/Link), minimal configuration.

Out of Scope:
- Organization-wide productivity benchmarking.
- Automated notifications or reminder workflows.
- Complex predictive scheduling models beyond indicative shift.
- Financial/resource capacity planning.

Major goals:
- MVP (2-day hackathon): Core flows with manual PM validation for progress accuracy.
- Near-term: Stabilize API integrations; refine delay heuristics; improve export formats.
- Future: Optional notifications; richer forecasting; capacity overlays.

## 📅 7. Timeline / Milestones
- Day 1 — Data & Hierarchy: Connect to work management APIs (e.g., Jira); fetch Epics, Stories, Bugs, Tasks; implement release membership via fixVersion/labels; render Epic → Story hierarchy with basic progress.
- Day 2 — Signals & Reporting: Add bugs/tasks visibility, delay highlighting with indicative timeline shift; implement report export (Markdown/PDF/Link); finalize manual PM confirmation flow.

Reasoning & constraints:
- Tight timeline prioritizes essential visibility and export; advanced forecasting deferred.
- Dependencies on data hygiene (consistent labels, issue links) and API limits may impact depth of signals.
- Bottlenecks: API rate limits, inconsistent status histories, cross-release linking edge cases.

## 📌 8. Strategic Differentiators
- Hierarchy-first: True Epic → Story hierarchy per release, even for spanning items.
- Risk signals integrated: Bugs (by priority) and tasks are visible alongside progress.
- Delay awareness: Indicative timeline shift surfaces downstream impact early without heavy modeling.
- Near‑zero manual publishing: One-click report generation reduces ad-hoc consolidation and increases consistency.
