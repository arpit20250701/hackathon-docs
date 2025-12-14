# Frontend Integration Implementation Flow

## 🎯 Overview

This guide details the step-by-step process for integrating the existing frontend (`New Project Setup`) with the backend APIs once they're ready.

**Prerequisites:**
- Backend APIs deployed and accessible
- Frontend project in `New Project Setup` folder
- API endpoints tested with Postman/curl

---

## 📋 Integration Phases

### **Phase 1: API Configuration (Day 1)**

#### Step 1: Update API Base URL

**File:** `New Project Setup/src/services/api.ts`

```typescript
// BEFORE (Mock mode)
const API_BASE_URL = '/api';
const MOCK_DELAY = 800;

// AFTER (Production mode)
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000/api';
// Remove MOCK_DELAY - no longer needed
```

#### Step 2: Create Environment Configuration

**File:** `New Project Setup/.env.development`

```bash
VITE_API_BASE_URL=http://localhost:3000/api
```

**File:** `New Project Setup/.env.production`

```bash
VITE_API_BASE_URL=https://your-production-domain.com/api
```

#### Step 3: Configure Vite Proxy (Optional - for development CORS)

**File:** `New Project Setup/vite.config.ts`

```typescript
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    extensions: ['.js', '.jsx', '.ts', '.tsx', '.json'],
    alias: {
      // ... existing aliases ...
      '@': path.resolve(__dirname, './src'),
    },
  },
  // Add proxy configuration for backend API
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:3000',
        changeOrigin: true,
        secure: false,
        rewrite: (path) => path, // Keep /api prefix
      },
    },
  },
});
```

**With proxy:**
- Frontend: `http://localhost:5173`
- API calls: `http://localhost:5173/api/*` → proxied to → `http://localhost:3000/api/*`
- No CORS issues during development

---

### **Phase 2: Replace Mock Functions (Day 1-2)**

#### Task 1: Replace `fetchProjects`

**File:** `New Project Setup/src/services/api.ts`

```typescript
// BEFORE (Mock)
export const fetchProjects = async (): Promise<Project[]> => {
  return mockApiCall([
    { id: 'proj-1', name: 'Customer Portal Redesign' },
    // ... mock data
  ]);
};

// AFTER (Real API)
export const fetchProjects = async (): Promise<Project[]> => {
  try {
    const response = await fetch(`${API_BASE_URL}/projects`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('Failed to fetch projects:', error);
    throw error;
  }
};
```

#### Task 2: Replace `fetchReleases`

```typescript
// BEFORE (Mock)
export const fetchReleases = async (projectId: string): Promise<Release[]> => {
  return mockApiCall([
    { id: 'rel-1', name: 'Q1 2024 Release', projectId },
    // ... mock data
  ]);
};

// AFTER (Real API)
export const fetchReleases = async (projectId: string): Promise<Release[]> => {
  try {
    const response = await fetch(
      `${API_BASE_URL}/releases?projectId=${encodeURIComponent(projectId)}`
    );
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    return data.items || []; // Backend returns { version, items, pageInfo }
  } catch (error) {
    console.error('Failed to fetch releases:', error);
    throw error;
  }
};
```

#### Task 3: Replace `fetchMetrics`

```typescript
// BEFORE (Mock)
export const fetchMetrics = async (releaseId: string): Promise<MetricData[]> => {
  return mockApiCall([/* mock metrics */]);
};

// AFTER (Real API)
export const fetchMetrics = async (releaseId: string): Promise<MetricData[]> => {
  try {
    // Use alias endpoint that backend provides
    const response = await fetch(`${API_BASE_URL}/releases/${releaseId}/metrics`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    
    // Transform backend KPIs to frontend MetricData format
    return transformKPIsToMetrics(data.kpis);
  } catch (error) {
    console.error('Failed to fetch metrics:', error);
    throw error;
  }
};

// Helper function to transform backend KPIs
function transformKPIsToMetrics(kpis: any): MetricData[] {
  return [
    {
      label: 'Overall Completion',
      value: kpis.overallCompletion || '0%',
      change: kpis.completionChange || '+0%',
      trend: kpis.completionTrend || 'neutral',
      icon: 'Target',
      color: 'text-[--color-chart-1]',
      bgColor: 'bg-[--color-chart-1] bg-opacity-10',
      cardBg: 'bg-gradient-to-br from-green-50 to-emerald-50'
    },
    {
      label: 'Epics Completed',
      value: kpis.epicsCompleted || '0/0',
      change: kpis.epicsPercentage || '0%',
      trend: 'neutral',
      icon: 'Layers',
      color: 'text-[--color-chart-2]',
      bgColor: 'bg-[--color-chart-2] bg-opacity-10',
      cardBg: 'bg-gradient-to-br from-orange-50 to-amber-50'
    },
    {
      label: 'Stories On Track',
      value: kpis.storiesOnTrack || '0/0',
      change: kpis.storiesPercentage || '0%',
      trend: 'neutral',
      icon: 'BookCheck',
      color: 'text-[--color-chart-1]',
      bgColor: 'bg-[--color-chart-1] bg-opacity-10',
      cardBg: 'bg-gradient-to-br from-blue-50 to-cyan-50'
    },
    {
      label: 'Delayed Items',
      value: String(kpis.delayedItems || 0),
      change: kpis.delayedChange || '+0',
      trend: (kpis.delayedItems || 0) > 0 ? 'down' : 'up',
      icon: 'Clock',
      color: 'text-primary',
      bgColor: 'bg-primary bg-opacity-10',
      cardBg: 'bg-gradient-to-br from-red-50 to-rose-50'
    },
    {
      label: 'Open Bugs',
      value: String(kpis.openBugs || 0),
      change: kpis.bugsChange || '0',
      trend: (kpis.openBugs || 0) < 10 ? 'up' : 'down',
      icon: 'ShieldAlert',
      color: 'text-primary',
      bgColor: 'bg-primary bg-opacity-10',
      cardBg: 'bg-gradient-to-br from-pink-50 to-fuchsia-50'
    },
    {
      label: 'Open Tasks',
      value: String(kpis.openTasks || 0),
      change: kpis.tasksChange || '0',
      trend: (kpis.openTasks || 0) < 50 ? 'up' : 'down',
      icon: 'ListTodo',
      color: 'text-[--color-chart-3]',
      bgColor: 'bg-[--color-chart-3] bg-opacity-10',
      cardBg: 'bg-gradient-to-br from-purple-50 to-violet-50'
    }
  ];
}
```

#### Task 4: Replace `fetchEpics`

```typescript
// BEFORE (Mock)
export const fetchEpics = async (releaseId: string): Promise<Epic[]> => {
  return mockApiCall([/* mock epics */]);
};

// AFTER (Real API)
export const fetchEpics = async (releaseId: string): Promise<Epic[]> => {
  try {
    // Use alias endpoint that backend provides
    const response = await fetch(`${API_BASE_URL}/releases/${releaseId}/epics`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    
    // Backend returns { version, release, epics, orphanedStories?, notes? }
    return data.epics || [];
  } catch (error) {
    console.error('Failed to fetch epics:', error);
    throw error;
  }
};
```

#### Task 5: Replace `fetchChartData`

```typescript
// BEFORE (Mock)
export const fetchChartData = async (releaseId: string): Promise<ChartData> => {
  return mockApiCall({/* mock chart data */});
};

// AFTER (Real API)
export const fetchChartData = async (releaseId: string): Promise<ChartData> => {
  try {
    const response = await fetch(`${API_BASE_URL}/releases/${releaseId}/charts`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('Failed to fetch chart data:', error);
    // Return empty chart data structure on error
    return {
      completionTrend: [],
      statusDistribution: [],
      velocityData: [],
      bugTrend: []
    };
  }
};
```

#### Task 6: Remove Mock Helper Function

```typescript
// DELETE THIS - no longer needed
const mockApiCall = <T,>(data: T, delay = MOCK_DELAY): Promise<T> => {
  return new Promise((resolve) => {
    setTimeout(() => resolve(data), delay);
  });
};
```

---

### **Phase 3: Error Handling & Loading States (Day 2)**

#### Task 1: Add Error Boundary Component

**File:** `New Project Setup/src/components/ErrorBoundary.tsx`

```typescript
import React, { Component, ErrorInfo, ReactNode } from 'react';
import { Alert, AlertDescription, AlertTitle } from './ui/alert';
import { AlertCircle } from 'lucide-react';

interface Props {
  children: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false
  };

  public static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Uncaught error:', error, errorInfo);
  }

  public render() {
    if (this.state.hasError) {
      return (
        <div className="flex items-center justify-center min-h-screen p-4">
          <Alert variant="destructive" className="max-w-lg">
            <AlertCircle className="h-4 w-4" />
            <AlertTitle>Something went wrong</AlertTitle>
            <AlertDescription>
              {this.state.error?.message || 'An unexpected error occurred'}
            </AlertDescription>
          </Alert>
        </div>
      );
    }

    return this.props.children;
  }
}
```

#### Task 2: Update App.tsx with Better Error Handling

**File:** `New Project Setup/src/App.tsx`

**IMPORTANT:** Your current `App.tsx` already has good error handling! Here's what to verify:

```typescript
// EXISTING error handling in App.tsx - VERIFY THIS WORKS:
if (error) {
  return (
    <div className="min-h-screen bg-background flex items-center justify-center">
      <div className="text-center">
        <p className="text-primary mb-4">{error}</p>
        <button 
          onClick={() => window.location.reload()} 
          className="px-4 py-2 bg-primary text-primary-foreground rounded-[--radius-md]"
        >
          Retry
        </button>
      </div>
    </div>
  );
}

// EXISTING loading state - VERIFY THIS WORKS:
{loading && !metrics.length ? (
  <div className="flex items-center justify-center py-12">
    <div className="text-muted-foreground">Loading dashboard data...</div>
  </div>
) : (
  // ... dashboard content
)}
```

**Optional Enhancement:** Add ErrorBoundary component only if you want to catch React component errors
```

#### Task 3: Add Loading Skeleton Components

**File:** `New Project Setup/src/components/LoadingSkeleton.tsx`

```typescript
import { Skeleton } from './ui/skeleton';

export function MetricsSkeleton() {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {[1, 2, 3, 4, 5, 6].map((i) => (
        <Skeleton key={i} className="h-32 w-full" />
#### Task 3: Enhanced Loading States (Optional)

**Your App.tsx already has basic loading!** Current implementation:

```typescript
// EXISTING - This already works!
{loading && !metrics.length ? (
  <div className="flex items-center justify-center py-12">
    <div className="text-muted-foreground">Loading dashboard data...</div>
  </div>
) : (
  // ... components
)}
```

**Optional Enhancement:** Add skeleton loading with existing `Skeleton` component:

**File:** `New Project Setup/src/components/LoadingSkeleton.tsx` (NEW FILE - Optional)

```typescript
import { Skeleton } from './ui/skeleton';

export function MetricsSkeleton() {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {[1, 2, 3, 4, 5, 6].map((i) => (
        <Skeleton key={i} className="h-32 w-full" />
      ))}
    </div>
  );
}

export function HierarchySkeleton() {
  return (
    <div className="space-y-4">
      {[1, 2, 3].map((i) => (
        <Skeleton key={i} className="h-48 w-full" />
      ))}
    </div>
  );
}
```

**Then update App.tsx to use skeletons:**

```typescript
{loading && !metrics.length ? (
  <>
    <MetricsSkeleton />
    <HierarchySkeleton />
  </>
) : (
  // ... dashboard content
)} ] Frontend dev server running on `http://localhost:5173`
- [ ] No CORS errors in browser console
- [ ] Network tab shows API calls to correct endpoints

## Data Flow Testing

- [ ] Projects load in dropdown selector
- [ ] Selecting project loads releases
- [ ] Selecting release loads dashboard data
- [ ] Metrics display with correct values
- [ ] Hierarchy view shows epics and stories
- [ ] Charts render with real data

## Error Handling Testing

- [ ] Backend offline → shows error message
- [ ] Invalid release ID → shows empty state
- [ ] Network timeout → shows error and retry button
- [ ] Empty data → shows appropriate empty state message

## Edge Cases Testing

- [ ] Orphaned stories display correctly
- [ ] Spanning epics show partial indicators
- [ ] Delayed items highlighted properly
- [ ] Bug/task counts accurate
- [ ] Status colors match status categories

## Performance Testing

- [ ] Dashboard loads within 3 seconds
- [ ] No unnecessary API re-fetches
- [ ] Loading states show during data fetch
- [ ] Smooth transitions between selections
```

---

### **Phase 5: Production Readiness (Day 3-4)**

#### Step 1: Add API Error Logging

**File:** `New Project Setup/src/services/api.ts`

```typescript
// Add error logging utility
function logApiError(endpoint: string, error: any) {
  console.error(`API Error [${endpoint}]:`, {
    message: error.message,
    status: error.status,
    timestamp: new Date().toISOString(),
  });
  
  // In production, send to error tracking service
  if (import.meta.env.PROD) {
    // Example: Sentry.captureException(error);
  }
}

// Use in all fetch functions
export const fetchProjects = async (): Promise<Project[]> => {
  try {
    const response = await fetch(`${API_BASE_URL}/projects`);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return await response.json();
  } catch (error) {
    logApiError('fetchProjects', error);
    throw error;
  }
};
```

#### Step 2: Add Request Timeout

```typescript
// Utility function
async function fetchWithTimeout(url: string, options: RequestInit = {}, timeout = 10000) {
  const controller = new AbortController();
  const id = setTimeout(() => controller.abort(), timeout);
  
  try {
    const response = await fetch(url, {
      ...options,
      signal: controller.signal
    });
    clearTimeout(id);
    return response;
  } catch (error) {
    clearTimeout(id);
    throw error;
  }
}

// Use in API calls
export const fetchProjects = async (): Promise<Project[]> => {
  try {
    const response = await fetchWithTimeout(`${API_BASE_URL}/projects`);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return await response.json();
  } catch (error) {
    logApiError('fetchProjects', error);
    throw error;
  }
};
```

#### Step 3: Add Response Caching (Optional)

```typescript
// Simple in-memory cache
const cache = new Map<string, { data: any; timestamp: number }>();
const CACHE_TTL = 5 * 60 * 1000; // 5 minutes

function getCachedData<T>(key: string): T | null {
  const cached = cache.get(key);
  if (!cached) return null;
  
  const isExpired = Date.now() - cached.timestamp > CACHE_TTL;
  if (isExpired) {
    cache.delete(key);
    return null;
  }
  
  return cached.data as T;
}

function setCachedData<T>(key: string, data: T): void {
  cache.set(key, { data, timestamp: Date.now() });
}

// Use in API calls
export const fetchReleases = async (projectId: string): Promise<Release[]> => {
  const cacheKey = `releases_${projectId}`;
  const cached = getCachedData<Release[]>(cacheKey);
  if (cached) return cached;
  
  try {
    const response = await fetchWithTimeout(
      `${API_BASE_URL}/releases?projectId=${encodeURIComponent(projectId)}`
    );
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const data = await response.json();
    const releases = data.items || [];
    setCachedData(cacheKey, releases);
    return releases;
  } catch (error) {
    logApiError('fetchReleases', error);
    throw error;
  }
};
```

---

## 🚀 Quick Start Commands

### Start Development Environment

```bash
# Terminal 1: Start Backend
cd apps/bff-hk-gamar
npm run start:dev

# Terminal 2: Start Frontend
cd "New Project Setup"
npm install  # if not done already
npm run dev

# Open browser
open http://localhost:5173
```

### Verify Integration

```bash
# Check backend health
curl http://localhost:3000/api/health

# Check projects endpoint
curl http://localhost:3000/api/projects

# Check releases endpoint
curl "http://localhost:3000/api/releases?projectId=PROJ-1"

# Open browser DevTools and check:
# - Network tab for API calls
# - Console for errors
```

---

## 🔍 Troubleshooting Guide

### Issue: CORS Errors

**Symptoms:** Browser console shows CORS policy errors

**Solutions:**
1. Ensure backend has CORS enabled in `main.ts`
2. Use Vite proxy configuration (see Phase 1, Step 3)
3. Check `Access-Control-Allow-Origin` headers in backend

### Issue: API Returns 404

**Symptoms:** All API calls fail with 404

**Solutions:**
1. Verify backend is running: `curl http://localhost:3000/api/health`
2. Check API base URL in frontend `.env` file
3. Verify endpoint paths match backend routes

### Issue: Empty Data Display

**Symptoms:** UI loads but shows no data

**Solutions:**
1. Check backend database has data: `npx prisma studio`
2. Run ingestion pipeline to populate database
3. Check browser DevTools Network tab for API responses
4. Verify DTO transformation functions

### Issue: Slow Loading

**Symptoms:** Dashboard takes >5 seconds to load

**Solutions:**
1. Check backend API response times
2. Optimize database queries (add indexes)
3. Enable response caching
4. Use pagination for large datasets

---

## ✅ Integration Completion Checklist

### Phase 1: Configuration
- [ ] API base URL configured
- [ ] Environment files created
- [ ] Vite proxy configured (if needed)
- [ ] CORS working correctly

### Phase 2: API Integration
- [ ] All mock functions replaced
- [ ] `fetchProjects` working
- [ ] `fetchReleases` working
- [ ] `fetchMetrics` working
- [ ] `fetchEpics` working
- [ ] `fetchChartData` working

### Phase 3: Error Handling
- [ ] Error boundary component added
- [ ] Loading skeletons implemented
- [ ] Error messages display correctly
- [ ] Retry mechanism works

### Phase 4: Testing
- [ ] All API endpoints tested
- [ ] Data displays correctly in UI
- [ ] Error scenarios handled
- [ ] Edge cases validated
- [ ] Performance acceptable (<3s load)

### Phase 5: Production Ready
- [ ] Error logging implemented
- [ ] Request timeouts added
- [ ] Caching implemented (optional)
- [ ] Production environment variables set
- [ ] Final end-to-end testing passed

---

## 📚 Related Documentation

- [Backend Implementation Flow](./implementation-flow.md)
- [APP-APIS Development Tasks](./APP-APIS/phase-1-development-tasks.md)
- [Technical Specifications](./APP-APIS/phase-1-technical-spec.md)

---

## 🎉 Success Criteria

Your frontend integration is complete when:

1. ✅ Dashboard loads with real Jira data
2. ✅ All metrics calculate correctly
3. ✅ Epic-Story hierarchy displays properly
4. ✅ Bug and task counts are accurate
5. ✅ Error states handled gracefully
6. ✅ Performance meets requirements (<3s load time)
7. ✅ No console errors or warnings
8. ✅ Ready for demo to stakeholders

**Congratulations! Your MVP is now fully integrated!** 🚀
