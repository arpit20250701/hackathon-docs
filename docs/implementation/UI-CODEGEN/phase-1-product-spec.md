# PRD - Phase 1

## 1. Module Overview

- **Purpose:** Generate and scaffold HALDI’s base UI from Figma designs, providing core screens and navigation without live data binding.
- **Business Value:** Accelerates MVP delivery by establishing a consistent, reusable UI shell aligned to design, enabling rapid integration of data and features.
- **User Value:** Gives PM/DM users a navigable interface to select releases and preview hierarchy/KPI layouts, setting expectations for forthcoming functionality.
- **Module Type:** Core (Foundation)
- **Phase 1 Scope:** Figma-to-code generation, routing and page scaffolds, static UI for Release Selector, Hierarchy View, KPI Summary; no backend integration.

## 2. Scope & Boundaries

- **In Scope:**
    - Figma-based component/page generation for `apps/ui-hk-gamar`.
    - App routing and navigation tabs consistent with Material theme.
    - Static layouts for Release Selector, Epic → Story Hierarchy, KPI Summary, and placeholder panes for Bugs/Tasks/Delays.
    - Responsive styles and accessibility baseline (keyboard nav, semantic markup).
    - Theming setup aligned with mkdocs/material style (light/dark toggle awareness).
- **Out of Scope:**
    - Live data fetching, API calls, or state management.
    - Report export (PDF/Markdown/Link).
    - Delay calculations or dynamic KPI computation.
    - Authentication/authorization.
- **Dependencies:**
    - Figma design artifacts and tokens for codegen.
    - Repository structure `apps/ui-hk-gamar` ready to receive generated components.
- **Dependents:**
    - USER-INTERFACE (Phase 2) binds these UI shells to APP-APIS.
    - REPORTING leverages established component structure for export views.

## 3. User Personas & Contexts

- **Persona:** Project Manager / Delivery Manager
- **Goals:** Navigate releases; view hierarchical layout and KPIs framework to understand intended capabilities.
- **Context:** Early MVP; validating UI flows and layout before data integration.
- **Pain Points:** Fragmented views and inconsistency; need predictable UI shell that will host real signals later.

## 4. User Stories

- **US-UI-CODEGEN-001:** As a PM, I want a Release Selector screen so that I can choose a target release to view in subsequent pages.
  - **Priority:** High
  - **Acceptance Criteria:**
    - Given the app loads, when I open Release Selector, then I see a list UI placeholder with filter/search controls.
    - Given I select a placeholder release, when I proceed, then routing moves me to Hierarchy View with the selected release context displayed statically.
- **US-UI-CODEGEN-002:** As a PM, I want a hierarchical Epic → Story layout so that I understand the structure of the release view.
  - **Priority:** High
  - **Acceptance Criteria:**
    - Given Hierarchy View, when I expand an Epic, then I see nested Story items (static).
    - Given spanning/multi-linked/orphan sections, when I navigate, then I see labeled placeholders indicating edge-case handling in later phases.
- **US-UI-CODEGEN-003:** As a PM, I want KPI Summary tiles so that I can see where progress/quality/workload metrics will appear.
  - **Priority:** Medium
  - **Acceptance Criteria:**
    - Given KPI Summary, when I view the top section, then I see tiles for completion, epics completed, stories on track, open bugs, open tasks, delayed items (static counts).
- **US-UI-CODEGEN-004:** As a PM, I want tabs/sections for Bugs, Tasks, and Delays so that I can preview the UI for signals.
  - **Priority:** Medium
  - **Acceptance Criteria:**
    - Given signals tabs, when I switch tabs, then I see static lists/placeholders with priority/status legends.

## 5. Functional Requirements

- **FR-UI-CODEGEN-001:** Generate base UI components and pages from Figma designs into `apps/ui-hk-gamar`.
  - **Related Project FR:** Supports overall MVP UI as per roadmap foundation.
  - **Module Context:** Establishes the screens required by core use cases without data.
- **FR-UI-CODEGEN-002:** Implement routing for Release Selector → Hierarchy → KPI Summary with navigation tabs.
  - **Related Project FR:** Aligns to hierarchical view and signals structure.
  - **Module Context:** Ensures coherent navigation paths for later data binding.
- **FR-UI-CODEGEN-003:** Provide accessible, responsive layouts using the project’s Material theme.
  - **Related Project FR:** Usability non-functional requirements.
  - **Module Context:** Baseline UX consistency across screens.
- **FR-UI-CODEGEN-004:** Include placeholders for edge cases (spanning epics, multi-linked stories, orphaned items).
  - **Related Project FR:** Edge case handling guidance (to be made dynamic later).
  - **Module Context:** Visual cues for future logic.

## 6. Business Rules & Logic

- **BR-UI-CODEGEN-001:** UI must mirror Figma structure and naming to reduce drift.
  - **Example:** Component names and layout regions match Figma frames.
  - **Edge Cases:** If designs are incomplete, scaffold generic components with clear TODO tags.
- **BR-UI-CODEGEN-002:** Navigation and page structure must anticipate data-binding without major refactor.
  - **Example:** Containers accept future props/state without structural changes.
  - **Edge Cases:** Provide adapter points for APP-APIS responses.

## 7. User Interface Requirements

- **Screen/Page:** Release Selector
  - **Purpose:** Choose a release; search/filter controls (static).
  - **Key Elements:** Header, list/grid placeholder, search bar, proceed CTA.
  - **User Flow:** Selector → Hierarchy View.
  - **Validation Rules:** None (no backend yet).
- **Screen/Page:** Hierarchy View
  - **Purpose:** Present Epic → Story tree (static).
  - **Key Elements:** Expandable Epic cards, nested Story items, edge-case badges (Partial/Multi-linked/Unlinked).
  - **User Flow:** From Release Selector; tabs to signals and KPI Summary.
  - **Validation Rules:** N/A.
- **Screen/Page:** KPI Summary & Signals
  - **Purpose:** Show KPI tiles and tabs for Bugs, Tasks, Delays (static).
  - **Key Elements:** KPI tiles; tabbed panes; legends.
  - **User Flow:** Navigable from Hierarchy View.
  - **Validation Rules:** N/A.

## 8. Data Requirements

- **Input Data:** None (static placeholders only).
- **Output Data:** None.
- **Stored Data:** None (no persistence in Phase 1).

## 9. Integration Specifications

- **APIs/Interfaces:** None in Phase 1.
- **Events:** None.
- **Data Flow:** N/A.
- **Error Handling:** Client-side route guards and fallback UI for missing pages.

## 10. Performance & Quality Requirements

- **Performance:** Screens load in ≤ 2 seconds locally; routing instantaneous.
- **Reliability:** UI builds consistently across environments; no runtime errors in static navigation.
- **Security:** No secrets or auth in Phase 1.
- **Usability:** Basic accessibility: focus states, keyboard navigation, semantic landmarks.

## 11. Success Metrics

- **Business Metrics:** Faster MVP velocity; reduced rework during data binding.
- **User Metrics:** PM/DM can navigate target screens without confusion (qualitative test).
- **Technical Metrics:** ≤ 1 structural change required when binding to APP-APIS; lighthouse accessibility baseline ≥ 80 (static).

## 12. Edge Cases & Error Scenarios

- **Error Case 1:** Missing or outdated Figma tokens.
  - **User Experience:** Display a developer-facing setup note; proceed with generic scaffolds.
  - **System Behavior:** Skip codegen; use placeholder components.
- **Edge Case 1:** Incomplete designs for a screen.
  - **Business Logic:** Scaffold minimal viable layout with TODO markers.
  - **User Impact:** Users still see the path and structure.

## 13. Future Considerations

- **Enhancement 1:** Bind Release Selector to `/releases` API; load real lists.
- **Enhancement 2:** Render dynamic hierarchy via `/release/:id/hierarchy` with progressive loading.
- **Enhancement 3:** Populate KPI tiles and signals from `/release/:id/signals`.

## 14. Acceptance Criteria Summary

- [ ] Figma-driven components/pages generated in `apps/ui-hk-gamar`.
- [ ] Routing across Release Selector, Hierarchy View, KPI Summary works.
- [ ] Static placeholders for edge cases and signals present.
- [ ] Responsive and accessible baseline achieved.

## 15. Open Questions

- **Question 1:** Which specific Figma file/pages should be the source of truth for codegen?
- **Question 2:** Do we standardize component naming conventions to align with backend domain (Release/Epic/Story)?
