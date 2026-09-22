# InsightFlow — Complete QA Feature & Route Inventory

## 1. System Overview & Architecture
- **Application Name**: InsightFlow — Enterprise Analytics & AI BI Platform
- **Frontend Stack**: React 18 (TypeScript), Vite, Zustand, TanStack Query, Recharts, Lucide Icons, Custom Design System
- **Backend Stack**: FastAPI (Python 3.12), SQLAlchemy (SQLite/PostgreSQL), Pandas, NumPy, Pydantic v2, PyJWT, OpenRouter/LLM
- **Authentication**: JWT Bearer Token (Admin / Customer RBAC)
- **Reporting Engine**: Power BI-inspired Multi-page Canvas, Visual Registry (15+ Visual Types), DAX Formula Engine, Live Data Public Sharing

---

## 2. Master Feature Inventory Table

| ID | Module | Feature | UI Location | Backend API / Method | Expected Ground-Truth Result | Priority |
|---|---|---|---|---|---|---|
| **AUTH-001** | Authentication | Admin Login | `/login` | `POST /api/auth/login` | Returns JWT token, user profile with `role='admin'`, redirects to Admin Dashboard | P0 |
| **AUTH-002** | Authentication | Customer Login | `/login` | `POST /api/auth/login` | Returns JWT token, user profile with `role='customer'`, redirects to Customer Portal (`/customer/reports`) | P0 |
| **AUTH-003** | Authentication | Logout | Navbar / Sidebar | Client side state clear + redirect to `/login` | Token removed from localStorage, redirect to login page | P0 |
| **AUTH-004** | Authentication | Invalid Credentials | `/login` | `POST /api/auth/login` | HTTP 401 Unauthorized, displays error toast, no session created | P0 |
| **AUTH-005** | Authentication | Protected Route Guard | All `/admin/*` routes | Frontend Auth Guard & Backend `get_current_user` | HTTP 401/403, redirects unauthenticated requests to `/login` | P0 |
| **RBAC-001** | RBAC / Authorization | Admin Full Access | All admin pages | Dependency `require_admin` | Admin can create projects, upload datasets, manage users, edit reports | P0 |
| **RBAC-002** | RBAC / Authorization | Customer Restricted Access | `/customer/*` | Dependency `get_current_user` | Customer cannot access `/admin/*` routes or admin APIs (HTTP 403) | P0 |
| **RBAC-003** | RBAC / Authorization | Project Permission Check | Project View | `GET /api/projects/{id}` | Only assigned users or admins can access specific project resources | P1 |
| **RBAC-004** | RBAC / Authorization | Report Assignment to Customer | `/admin/users` | `PUT /api/users/{id}/permissions` | Assigned reports are visible in Customer Portal; unassigned reports are hidden | P0 |
| **PROJ-001** | Projects | List Projects | `/admin/projects` | `GET /api/projects` | Displays all workspace projects with dataset count, report count, status | P1 |
| **PROJ-002** | Projects | Create Project | `/admin/projects` | `POST /api/projects` | Creates project in DB, logs audit event, updates UI list | P1 |
| **PROJ-003** | Projects | Project Analytics Summary | `/admin/projects/{id}` | `GET /api/ai/project-overview/{id}` | Computes dynamic KPIs, health score, cross-dataset relationships | P1 |
| **DATA-001** | Datasets | Upload Single CSV | `/admin/datasets` | `POST /api/datasets/upload` | Parses CSV, creates SQLite/DuckDB table, profiles columns, returns profile | P0 |
| **DATA-002** | Datasets | Upload Multi-File (Zip/Batch) | `/admin/datasets` | `POST /api/datasets/upload` | Ingests multiple files, creates distinct datasets under project | P1 |
| **DATA-003** | Datasets | Upload Excel (.xlsx/.xls) | `/admin/datasets` | `POST /api/datasets/upload` | Parses first sheet or selected sheet, auto-infers data types | P1 |
| **DATA-004** | Datasets | Connect Database (Postgres/MySQL/SQLite) | `/admin/datasets` | `POST /api/datasets/connect-database` | Tests connection, discovers tables/views, ingests selected table | P1 |
| **DATA-005** | Datasets | Automated Data Profiling | `/admin/datasets/{id}` | `GET /api/datasets/{id}/profile` | Calculates exact row count, col count, nulls, unique values, min/max/mean/median | P0 |
| **DATA-006** | Datasets | Data Preview & Pagination | `/admin/datasets/{id}` | `GET /api/datasets/{id}/preview` | Returns paginated raw rows (50/100/200 per page) with column types | P1 |
| **DATA-007** | Datasets | Data Health Scoring (0-100) | `/admin/datasets/{id}` | `compute_data_health` | Authoritative score based on completeness, integrity, sample size, type diversity | P1 |
| **DATA-008** | Datasets | Semantic Domain Understanding | `/admin/datasets/{id}` | `GET /api/ai/dataset-domain/{id}` | Classifies domain (Government, Finance, Healthcare, HR, Logistics, SaaS, Retail, Custom) | P0 |
| **DASH-001** | Dashboard Builder | Multi-Page Canvas | `/admin/reports/{id}/builder` | `GET/POST /api/reports/{id}/dashboard` | Allows adding, renaming, switching, and deleting dashboard canvas pages | P0 |
| **DASH-002** | Dashboard Builder | Visual Drag & Drop / Resize | Builder Canvas | Grid Layout System | Interactive grid repositioning (x, y, w, h) with responsive auto-fit | P0 |
| **DASH-003** | Dashboard Builder | Visual Type Selection | Visuals Panel | Visual Registry | Supports 15+ visual types (KPI, Card, Bar, Column, Line, Area, Pie, Donut, Treemap, Funnel, Waterfall, Scatter, Combo, Table, Matrix, Gauge, Text, Slicer) | P0 |
| **DASH-004** | Dashboard Builder | Power BI DAX Formula Bar | Builder Header | `POST /api/reports/{id}/measures` | Parses DAX expressions (`DIVIDE`, `SUM`, `AVERAGE`, `COUNT`, math operators), creates calculated measure | P0 |
| **DASH-005** | Dashboard Builder | Visual Action Toolbar | Visual Header | Focus Mode, Sort Asc/Desc, CSV Data Export, Toggle Data Labels | Allows detailed full-screen visual inspection, export, and sorting | P1 |
| **DASH-006** | Dashboard Builder | Visual Cross-Filtering | Visual Canvas | Filter Service & VisualRenderer | Clicking a bar/pie slice applies filter across all visuals on canvas | P1 |
| **DASH-007** | Dashboard Builder | Safe Rendering Limit Safeguard | VisualRenderer | `slice(0, 50)` & `max_limit` | Prevents browser thread lock on 200k+ row datasets | P0 |
| **AI-001** | AI Engine | Semantic AI Dashboard Generation | Builder Modal | `POST /api/ai/generate-dashboard` | Synthesizes domain-tailored dashboard layout, KPIs, and charts (No sales bias) | P0 |
| **AI-002** | AI Engine | Natural Language Custom Requirements | Builder Modal | `POST /api/ai/generate-dashboard` | Respects user prompt (e.g. "Focus on allocation vs expenditure by department") | P0 |
| **AI-003** | AI Engine | Ask InsightFlow (Natural Language Q&A) | AI Analytics Page | `POST /api/ai/ask/{datasetId}` | Natural language analytics answer backed by ground-truth statistics & citations | P0 |
| **AI-004** | AI Engine | Structured Explainable Insights | AI Analytics Page | `POST /api/ai/explain/{datasetId}` | Returns structured findings with evidence, impact analysis, and action items | P1 |
| **AI-005** | AI Engine | Dynamic KPI Discovery | Dataset / AI Page | `GET /api/ai/recommendations/{id}` | Discovers authentic business KPIs from dataset schema (No fake metrics) | P1 |
| **REP-001** | Reports & Sharing | Publish Report | Builder Header | `POST /api/reports/{id}/publish` | Generates secure public share token, sets `is_published=True` | P0 |
| **REP-002** | Reports & Sharing | Public Shareable Report Viewer | `/public/report/{token}` | `GET /api/reports/public/token/{token}` | Public viewer displays ONLY the published report without navigation bars | P0 |
| **REP-003** | Reports & Sharing | Live Query in Public Viewer | Public Viewer | `POST /api/reports/public/visual` | Queries live data from underlying dataset so viewer always sees updated numbers | P0 |
| **REP-004** | Reports & Sharing | Regenerate Share Link | Builder Share Modal | `POST /api/reports/{id}/regenerate-share-link` | Invalidates old token and issues new cryptographic token | P1 |
| **EXP-001** | Exports | Export Dataset CSV | Dataset Page | `GET /api/exports/dataset/{id}/csv` | Streams formatted CSV download of dataset rows | P1 |
| **EXP-002** | Exports | Export Visual Data CSV | Visual Header | Client CSV generator | Exports exact underlying aggregated dataset of the visual | P1 |
| **EXP-003** | Exports | Export Report JSON/Summary | Reports Page | `GET /api/exports/report/{id}` | Exports complete report configuration and visual metadata | P2 |
| **USER-001** | User Management | List Users & Roles | `/admin/users` | `GET /api/users` | Displays all registered accounts with role, email, project count, status | P1 |
| **USER-002** | User Management | Create User (Admin/Customer) | `/admin/users` | `POST /api/users` | Creates user with hashed password, assigns initial role and project permissions | P0 |
| **USER-003** | User Management | Toggle Active / Delete User | `/admin/users` | `DELETE/PUT /api/users/{id}` | Deactivates or removes user account safely | P1 |
| **AUDIT-001** | Governance | Audit Activity Logging | `/admin/dashboard` | `GET /api/activity` | Records login, dataset upload, AI generation, publish, export, and user events | P1 |
