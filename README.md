# Customer Outreach Navigator

A Power Apps Canvas app that helps field sales reps find nearby distributors, see each account's sales history, log follow-up activity, and work a follow-up calendar — all from a phone or tablet.

> **Client engagement.** Built as a production solution for a client in the commercial door & hardware manufacturing industry. Company names, addresses, and account details shown in the screenshots have been replaced with fictional equivalents to protect client confidentiality.

## The Problem

A field sales rep is in a town for one appointment. While they're there, *who else nearby should they be visiting?* Without a tool, the answer lived in someone's memory or a spreadsheet back at the office — so reps drove past under-served accounts without knowing, and follow-ups got promised on sticky notes and forgotten. There was no way, standing in a parking lot, to ask "who's around me, and which of them are worth my time today?"

## The Solution

Put the answer in the rep's pocket, backed by the company's own sales data:

1. The rep picks a **state and city** and taps **Find Nearby Distributors** — the app returns accounts within a radius, each tagged with its **order count and total sales** so the rep instantly sees active vs. low vs. untapped accounts.
2. Behind the scenes, nearby results are served from a **SQL cache** that a **Power Automate** flow refreshes on a schedule from a maps/places API — so the app is fast and doesn't hit (or pay for) the external API on every open.
3. A SQL view tiers customers by sales and surfaces the **lowest tier**, so the rep can prioritise the accounts that need attention.
4. After a visit, the rep **logs the interaction** (type, status, notes) and sets the **next follow-up date** — which then drives a **follow-up calendar** so nothing slips.

The result: a rep can walk into any town and immediately know who to see and who to chase.

## How It Works

```
 Field sales rep (phone/tablet)            Back-office data
 ┌──────────────────────────────┐         ┌──────────────────────────────┐
 │ Customer Outreach Navigator   │  read   │ SQL: distributor_cache        │
 │ (Power Apps Canvas)            ├────────►│  (nearby accounts + sales)    │
 │                               │         └──────────────┬───────────────┘
 │  choose state + city          │                        ▲ scheduled refresh
 │  → nearby accounts w/ sales   │                        │
 │  → log follow-up + next date  │  write  ┌──────────────┴───────────────┐
 │                               ├────────►│ Power Automate ← places API   │
 └──────────────┬───────────────┘         └──────────────────────────────┘
                │ write
                ▼
        ┌──────────────────────────────┐
        │ SQL: distributor_notes        │  → drives the follow-up calendar
        │  (interactions + next date)   │
        └──────────────────────────────┘
```

## Key Features

- **Location-based discovery** — choose state + city, find nearby distributors within a configurable radius.
- **Account context at a glance** — order count, total sales, and full address per distributor.
- **Follow-up logging** — record interaction type, status, notes, and the next follow-up date against any account.
- **Follow-up calendar** — a date-driven view of every account due for follow-up on a given day.
- **Cached discovery layer** — nearby-distributor results are cached in SQL and refreshed on a schedule by Power Automate, keeping the app fast and avoiding per-open API calls.
- **Low-sales targeting** — a SQL view tiers customers by sales (NTILE) and surfaces the lowest tier, so reps prioritise under-served accounts.

## Tech Stack

- **Power Apps** (Canvas app, phone/tablet layout)
- **SQL Server** data warehouse (cache table, notes table, reporting views)
- **Power Automate** (scheduled cache refresh from a maps/places API)

## Screenshots

| Distributor discovery | Follow-up calendar |
|---|---|
| ![Distributor list](screenshots/01-distributor-list.png) | ![Calendar follow-ups](screenshots/02-calendar-followups.png) |

## Data Model

See [`sql/`](sql/) for the backing objects:

- `01-distributor-cache.sql` — cached nearby-distributor results, refreshed by Power Automate.
- `02-distributor-notes.sql` — follow-up interactions logged by reps; drives the follow-up calendar.
- `03-sales-summary-views.sql` — `vw_CustomerSalesSummary` (sales + order count per customer) and `vw_LowSalesCustomers` (lowest sales tier).

---

*Screenshots use anonymized sample data. The database name (`ClientDW`) is a placeholder.*
