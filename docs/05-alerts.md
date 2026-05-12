# Sandbox Subscription Alerts

## Approach

Each sandbox subscription is monitored using **Azure Monitor native services** — no custom code, no external mail server, no additional platform to operate. The alert logic reads directly from the subscription's own tags and routes notifications through Azure's built-in delivery infrastructure.

---

## Deployed Resources

**Scheduled Query Rule**
A daily query that inspects the subscription's lifecycle tags and fires an alert when a condition is met.

**Action Group**
Defines who gets notified when the alert fires — the subscription owner and the ops team, reached by email.

---

## How It Works

The Scheduled Query Rule runs once per day against Azure Resource Graph. It checks the subscription's tags for two conditions:

- `sandbox-expiry` is within 30 days of today
- `sandbox-status` is `"disabled"`

If either condition is true, the alert fires and the Action Group sends an email to the subscription owner and the ops team. Notifications are limited to **Mondays** to avoid daily noise while keeping daily evaluation for accuracy.

---

## Schema

```
┌─────────────────────────────────────┐
│  Subscription tags                  │
│  sandbox-expiry  /  sandbox-status  │
└────────────────┬────────────────────┘
                 │ read daily
                 ▼
┌─────────────────────────────────────┐
│  Scheduled Query Rule               │
│  (Azure Monitor)                    │
│  evaluates every day,               │
│  fires on Mondays if condition met  │
└────────────────┬────────────────────┘
                 │ triggers
                 ▼
┌─────────────────────────────────────┐
│  Action Group                       │
└──────────┬──────────────┬───────────┘
           │              │
           ▼              ▼
     Owner email      Ops email
   (Azure Monitor delivery — no SMTP config)
```

---

## Advantages

**No mail infrastructure to manage**
Email delivery is fully handled by Azure Monitor. No SMTP server, no sending domain, no SPF/DKIM records. Microsoft manages deliverability as a platform service.

**No extra services**
Avoids provisioning Azure Communication Services Email, which requires its own domain verification workflow and separate billing. The Action Group email receiver achieves the same outcome — email to any address — out of the box.

**State lives in the subscription itself**
The alert reads expiry and status directly from the subscription's resource tags, which are the authoritative lifecycle state. No secondary database or external store is needed.

**Isolated per subscription**
Each sandbox gets its own alert rule scoped strictly to its subscription. There is no shared alerting resource to coordinate across sandboxes.

**Fully managed lifecycle**
Resources are provisioned and decommissioned alongside the subscription — no orphaned alert rules or action groups left behind when a sandbox is removed.
