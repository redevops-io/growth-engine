# redevops.io — Agentic Marketing Attribution & Channel Optimization

**Open-Source | Self-Hostable | AGPL Licensed**

> Stop guessing which marketing channels drive revenue. redevops.io is an open-core, agentic platform that gives SMEs enterprise-grade marketing attribution without the enterprise price tag.

---

## The Problem → Legacy → redevops.io

### 😖 The Pain
SMEs run **4–7 marketing channels simultaneously** with no reliable way to tell which ones drive revenue. Owners spend **12–20 hours per month** on manual reporting, and **$2,400–$19,200 annually** is wasted on underperforming channels. Traditional attribution tools are built for enterprises with **$500K+ budgets** — out of reach for businesses spending $2K–$8K/month on marketing.

### 🏚️ Legacy Approach
- **Manual spreadsheets & gut feel** — error-prone, unscalable, no real-time insight
- **Enterprise SaaS** (HubSpot, Northbeam, Triple Whale) — $500–$5,000+/month, locked-in, no data ownership
- **Siloed analytics** — Google Analytics, Meta Ads, LinkedIn Ads, email platforms each report in isolation
- **No agentic orchestration** — data pipelines require dedicated engineers to build and maintain

### 🚀 redevops.io
An **open-source, self-hostable agentic platform** using **PostHog**, **Matomo**, and **LangGraph** multi-agent orchestration. Owners get **business-outcome insights** without hiring analytics specialists or paying enterprise prices. Deploy on your own infrastructure — your data stays yours.

---

## Value Propositions

1. **Agentic Attribution Engine** — LangGraph-powered multi-agent system automatically correlates marketing spend across channels to revenue outcomes. No manual tagging, no complex setup.

2. **Open-Source & Self-Hostable** — Full AGPL license. Deploy on your own VPS, Kubernetes cluster, or Raspberry Pi. No per-seat fees, no data lock-in, no surprise price hikes.

3. **Enterprise-Grade Analytics Stack** — Built on battle-tested open-source components: **PostHog** for product analytics, **Matomo** for web analytics, **Grafana** for dashboards, and **ClickHouse** for high-performance querying.

4. **Privacy-First by Default** — Self-hosted means customer data never leaves your infrastructure. Compliant with GDPR, CCPA, and other privacy regulations out of the box.

5. **Affordable at SME Scale** — Free open-core for self-hosters. Managed cloud from **$500–$2,000/month**. Setup services from **$5K–$15K**. Compare to HubSpot at $5,000/month or Northbeam's private enterprise pricing.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Agent Layer (LangGraph)               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐ │
│  │ Channel  │  │Attribution│  │  Budget  │  │Insights │ │
│  │  Agent   │  │   Agent   │  │  Agent   │  │  Agent  │ │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬────┘ │
│       └──────────────┴─────────────┴──────────────┘      │
│                        │                                  │
│              ┌─────────▼──────────┐                      │
│              │  Orchestrator      │                      │
│              │  (LangGraph)       │                      │
│              └─────────┬──────────┘                      │
└────────────────────────┼─────────────────────────────────┘
                         │
┌────────────────────────▼─────────────────────────────────┐
│                   Open-Source Core                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │
│  │ PostHog  │  │  Matomo  │  │ClickHouse│  │  Grafana │ │
│  │(Product  │  │  (Web    │  │ (Columnar│  │(Dashboard│ │
│  │Analytics)│  │Analytics)│  │  Store)  │  │   & Viz) │ │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘ │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐               │
│  │ Firewall │  │   IDS    │  │ Billing  │               │
│  │(OPNsense)│  │(Suricata)│  │ (Lago)   │               │
│  └──────────┘  └──────────┘  └──────────┘               │
└──────────────────────────────────────────────────────────┘
```

### Open-Source Core Components

| Component | Role | Technology |
|-----------|------|------------|
| **Product Analytics** | Event tracking, funnel analysis, user journeys | [PostHog](https://posthog.com) |
| **Web Analytics** | Privacy-compliant page views, referrers, campaigns | [Matomo](https://matomo.org) |
| **Columnar Store** | High-performance analytical queries | [ClickHouse](https://clickhouse.com) |
| **Dashboards & Viz** | Real-time marketing dashboards | [Grafana](https://grafana.com) |
| **Firewall** | Network security & traffic filtering | [OPNsense](https://opnsense.org) |
| **IDS/IPS** | Intrusion detection & prevention | [Suricata](https://suricata.io) |
| **Billing** | Usage-based metering & invoicing | [Lago](https://getlago.com) |
| **Orchestration** | Multi-agent workflow management | [LangGraph](https://langchain.com/langgraph) |

### Agent Layer

The **LangGraph-powered agent layer** orchestrates specialized agents:

- **Channel Agent** — Ingests data from Google Ads, Meta Ads, LinkedIn, email, organic search, and direct traffic
- **Attribution Agent** — Applies multi-touch attribution models (linear, time-decay, U-shaped, data-driven)
- **Budget Agent** — Recommends optimal budget allocation across channels based on ROI
- **Insights Agent** — Generates natural-language summaries of what's working and what's not

---

## Quickstart

### Prerequisites

- **Docker** & **Docker Compose** (v2.20+)
- **Git**
- **4 GB RAM** minimum (8 GB recommended)
- Domain name (optional, for production)

### 1. Clone & Deploy

```bash
git clone https://github.com/redevops-io/redevops.git
cd redevops

# Start the full stack
docker compose up -d

# Check status
docker compose ps
```

### 2. Access Services

| Service | URL | Default Credentials |
|---------|-----|-------------------|
| **PostHog** | `http://localhost:8000` | `admin@redevops.local` / `changeme` |
| **Matomo** | `http://localhost:8080` | `admin` / `changeme` |
| **Grafana** | `http://localhost:3000` | `admin` / `admin` |
| **API** | `http://localhost:8081` | API key in `.env` |

### 3. Configure Marketing Channels

```bash
# Add your channel API keys
cp .env.example .env
# Edit .env with your:
#   - GOOGLE_ADS_CLIENT_ID
#   - META_ADS_ACCESS_TOKEN
#   - LINKEDIN_ADS_CLIENT_ID
#   - MAILCHIMP_API_KEY

# Restart to apply
docker compose restart agents
```

### 4. View Attribution Reports

Open **Grafana** → **Marketing Attribution Dashboard** to see:

- Revenue by channel (last 7/30/90 days)
- Cost per acquisition (CPA) per channel
- Return on ad spend (ROAS)
- Multi-touch attribution breakdown
- Budget optimization recommendations

### 5. Production Deployment

```bash
# Set up with TLS and domain
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Configure OPNsense firewall rules
# Configure Suricata IDS rules
# Set up Lago billing with your Stripe key
```

See **[docs/production.md](docs/production.md)** for full production guide.

---

## License

**AGPL-3.0** — Free to use, modify, and self-host. Commercial use requires a commercial license for closed-source distribution.

## Pricing

| Tier | Price | Includes |
|------|-------|----------|
| **Open Core** | Free | Self-hosted, all core features, community support |
| **Setup Services** | $5K–$15K | Deployment, configuration, custom integrations |
| **Managed Cloud** | $500–$2K/mo | Hosted, managed, SLA-backed, priority support |

---

## Community & Support

- [GitHub Issues](https://github.com/redevops-io/redevops/issues) — Bug reports & feature requests
- [Discord](https://discord.gg/redevops) — Community discussion
- [Documentation](https://docs.redevops.io) — Full docs
- Email: `hello@redevops.io`

---

*Built with ❤️ for SMEs who deserve to know which half of their ad budget is working.*