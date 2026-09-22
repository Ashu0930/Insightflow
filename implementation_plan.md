# InsightFlow — Full-Stack Implementation Plan

A production-style analytics and reporting platform built as a complete working full-stack system.

---

## User Review Required

> [!IMPORTANT]
> This is a **large multi-phase project**. Each phase builds on the previous. The Dashboard Builder is the #1 priority feature per the spec.

> [!WARNING]
> **Prerequisites needed before starting:**
> - PostgreSQL must be installed and running locally
> - Node.js (v18+) must be installed
> - Python 3.10+ must be installed
> - An AI API key (Google Gemini or OpenAI) is needed for the AI insights/recommendations features
>
> Please confirm these are available, or let me know which ones to skip/mock.

---

## Open Questions

> [!IMPORTANT]
> **AI Provider**: The spec references an AI API key. Which provider should be used?
> - Google Gemini (recommended — free tier available)
> - OpenAI (GPT-4)
> - Mock AI (no external calls — generates insights from pure Python stats)
>
> If you haven't decided, I'll default to **Mock AI** (Python-only insights, no API key required) and make it easy to swap in a real provider later.

---

## Project Structure

```
d:\AntiGravity\new Insight Project\
├── backend/                    # Python FastAPI backend
│   ├── app/
│   │   ├── main.py
│   │   ├── config.py
│   │   ├── database.py
│   │   ├── api/               # Route handlers
│   │   ├── models/            # SQLAlchemy ORM models
│   │   ├── schemas/           # Pydantic schemas
│   │   ├── services/          # Business logic
│   │   ├── repositories/      # DB access layer
│   │   └── security/          # Auth/JWT
│   ├── migrations/            # Alembic migrations
│   ├── uploads/               # Dataset file storage
│   ├── tests/
│   ├── requirements.txt
│   └── .env.example
│
└── frontend/                   # React + Vite frontend
    ├── src/
    │   ├── components/
    │   │   ├── layout/
    │   │   ├── charts/
    │   │   ├── dashboard/
    │   │   ├── filters/
    │   │   ├── tables/
    │   │   └── common/
    │   ├── pages/
    │   ├── services/
    │   ├── store/
    │   ├── types/
    │   └── utils/
    └── ...config files
```

---

## Proposed Changes

### Phase 1 — Project Foundation

#### [NEW] Backend project scaffold
- `backend/requirements.txt` — all Python dependencies
- `backend/.env.example` — environment variable template
- `backend/app/main.py` — FastAPI app entry point with CORS
- `backend/app/config.py` — settings using pydantic-settings
- `backend/app/database.py` — SQLAlchemy async engine + session

#### [NEW] Database Models (`backend/app/models/`)
- `user.py` — users table (id, name, email, password_hash, role, status)
- `project.py` — projects table
- `dataset.py` — datasets table (schema_json, profile_json)
- `report.py` — reports table (configuration_json)
- `report_page.py` — report_pages table
- `access.py` — project_users, report_users tables
- `measure.py` — calculated_measures table
- `audit.py` — audit_logs table

#### [NEW] Alembic migrations (`backend/migrations/`)
- Initial migration creating all tables
- Seed script for demo accounts + demo data

---

### Phase 2 — Authentication

#### [NEW] Auth API (`backend/app/api/auth.py`)
- `POST /api/auth/login` — JWT token generation
- `POST /api/auth/logout`
- `GET  /api/auth/me`

#### [NEW] Security (`backend/app/security/`)
- `jwt.py` — token creation/validation
- `password.py` — bcrypt hashing
- `dependencies.py` — FastAPI auth dependencies (get_current_user, require_admin)

---

### Phase 3 — Core APIs

#### [NEW] Projects API (`backend/app/api/projects.py`)
- Full CRUD: GET/POST/PUT/DELETE `/api/projects`

#### [NEW] Datasets API (`backend/app/api/datasets.py`)
- `POST /api/datasets/upload` — CSV upload + async processing
- `GET  /api/datasets/{id}/profile` — column stats
- `GET  /api/datasets/{id}/preview` — paginated rows

#### [NEW] Dataset Services (`backend/app/services/`)
- `dataset_service.py` — file handling, validation
- `profiling_service.py` — Pandas profiling (row count, null%, min/max/mean/median, unique count)

#### [NEW] Reports API (`backend/app/api/reports.py`)
- Full CRUD + publish/archive endpoints

#### [NEW] Dashboard API (`backend/app/api/dashboards.py`)
- `GET/PUT /api/reports/{id}/dashboard`
- Page CRUD endpoints

#### [NEW] Visual Query Engine (`backend/app/api/visuals.py`)
- `POST /api/visuals/query` — aggregation engine
- `POST /api/dashboard/filter` — filter application

#### [NEW] Query & Filter Services
- `query_service.py` — Pandas groupby/agg/sort/Top N
- `filter_service.py` — filter model evaluation
- `calculation_service.py` — calculated measures engine

#### [NEW] Export API (`backend/app/api/exports.py`)
- `POST /api/reports/{id}/export/excel` — openpyxl generation
- `POST /api/reports/{id}/export/csv`

#### [NEW] AI Service (`backend/app/services/ai_service.py`)
- Python-calculated stats → insight generation
- Dataset recommendations (KPIs, charts, filters)
- Data-backed narrative insights (no hallucination)

#### [NEW] Users API (`backend/app/api/users.py`)
- CRUD for user management
- Access assignment endpoints

#### [NEW] Audit API (`backend/app/api/activity.py`)
- Audit log recording middleware

---

### Phase 4 — Frontend Foundation

#### [NEW] Frontend scaffold (`frontend/`)
- Vite + React + TypeScript + Tailwind CSS
- React Router v6 for routing
- TanStack Query for server state
- Zustand for client state
- Recharts for charts
- React Grid Layout for dashboard canvas
- React DnD for drag-and-drop
- Lucide React icons

#### [NEW] Design System (`frontend/src/index.css`)
- Premium dark/light SaaS aesthetic
- Custom color tokens, typography (Inter font)
- Glassmorphism, gradients, micro-animations

#### [NEW] Layout Components (`frontend/src/components/layout/`)
- `Sidebar.tsx` — collapsible admin/customer nav
- `TopBar.tsx` — header with user menu
- `AdminLayout.tsx` / `CustomerLayout.tsx`

---

### Phase 5 — Admin Pages

#### [NEW] Auth Pages
- `pages/Login.tsx` — professional login with branding

#### [NEW] Admin Pages
- `pages/AdminDashboard.tsx` — KPI cards, recent activity, quick actions
- `pages/Projects.tsx` — project list with search/filter/pagination
- `pages/CreateProject.tsx` — project creation form
- `pages/ProjectOverview.tsx` — tabbed project view
- `pages/DatasetUpload.tsx` — CSV upload with progress stages
- `pages/DatasetProfile.tsx` — profiling stats + column details + preview
- `pages/ReportList.tsx` — report management
- `pages/UserManagement.tsx` — user CRUD + access assignment
- `pages/AIAnalytics.tsx` — recommendations + insights
- `pages/ActivityLog.tsx` — audit log viewer

---

### Phase 6 — Dashboard Builder (HIGHEST PRIORITY)

#### [NEW] Dashboard Builder (`pages/DashboardBuilder.tsx`)
Three-panel layout:
- **Left**: Visual type palette (collapsible)
- **Center**: React Grid Layout canvas with drag/drop
- **Right**: Data fields + Visual configuration panel (collapsible)
- **Bottom**: Page tabs + Filter/Slicer bar

#### [NEW] Visual Registry (`components/dashboard/`)
- `VisualRegistry.ts` — maps type → component + schema
- `VisualRenderer.tsx` — dynamic visual rendering
- `KPIVisual.tsx`
- `CardVisual.tsx`
- `BarChartVisual.tsx`
- `ColumnChartVisual.tsx`
- `LineChartVisual.tsx`
- `AreaChartVisual.tsx`
- `PieChartVisual.tsx`
- `DonutChartVisual.tsx`
- `ScatterVisual.tsx`
- `ComboVisual.tsx`
- `TableVisual.tsx`
- `MatrixVisual.tsx`
- `GaugeVisual.tsx`
- `TextVisual.tsx`

#### [NEW] Configuration Panels
- `FieldsPanel.tsx` — dataset fields browser (numeric/date/categorical)
- `VisualConfigPanel.tsx` — X/Y axis, aggregation, legend, tooltip, sort, Top N
- `FormattingPanel.tsx` — title, colors, data labels, number format, borders

#### [NEW] Filter & Slicer Components
- `FilterPanel.tsx` — visual/page/report level filter builder
- `SlicerVisual.tsx` — dropdown, multi-select, date range, numeric range

#### [NEW] Dashboard State (`store/dashboardStore.ts`)
- Zustand store for: current report, page, selected visual, filter context, layout, undo/redo history

---

### Phase 7 — Customer Portal

#### [NEW] Customer Pages
- `pages/CustomerDashboard.tsx` — assigned projects + recent reports
- `pages/CustomerReports.tsx` — report list
- `pages/ReportViewer.tsx` — read-only dashboard view with filters/slicers/export

---

### Phase 8 — Demo Data

#### [NEW] Demo Dataset (`backend/data/retail_sales_demo.csv`)
- 1,200+ rows of retail sales data
- Columns: Order_ID, Order_Date, Customer, Region, State, Product_Category, Product, Quantity, Revenue, Cost, Profit, Salesperson
- Multiple regions (Gujarat, Maharashtra, Rajasthan, Delhi, etc.)
- 12 months of data with meaningful trends + some missing values

#### [NEW] Seed Script (`backend/seed.py`)
- Creates admin + customer demo accounts
- Creates demo project + uploads demo dataset
- Creates and publishes a demo "Sales Performance Dashboard"

---

## Verification Plan

### Automated Tests
```bash
# Backend
cd backend && pytest tests/ -v

# Frontend
cd frontend && npm run build  # Type check + build
```

### Manual Verification
- Admin login → create project → upload CSV → profile → build dashboard (drag KPI + bar chart + line chart) → add slicers → save → publish → assign customer
- Customer login → view report → filter by region → all visuals update → export Excel
- Cross-filtering: click region in bar chart → all other visuals update

---

## Build Order Summary

| Phase | What gets built | Est. scope |
|---|---|---|
| 1 | Backend scaffold + DB models + auth | Foundation |
| 2 | Project/Dataset/Report APIs + services | Data layer |
| 3 | Frontend scaffold + layout + login | UI foundation |
| 4 | **Dashboard Builder** (full feature) | Core feature |
| 5 | Customer portal + report viewer | Customer flow |
| 6 | Export + AI insights | Enhancement |
| 7 | Seed data + demo dashboard | Polish |
