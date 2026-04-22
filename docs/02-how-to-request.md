# How to Request a Sandbox Subscription

## Before You Request

Check whether you actually need a new subscription. If you are:
- Continuing work from a previous sandbox → request an **extension** of your existing one.
- Working with a colleague on the same experiment → consider sharing their subscription.
- Running automated tests in a CI/CD pipeline → a sandbox may not be the right fit; talk to the platform team.

---

## Opening a Request Ticket

Open a ticket in the internal ticketing tool with the following information:

### Required Fields

| Field | Example | Notes |
|---|---|---|
| **Title** | `[Sandbox Request] API gateway prototype - jdoe` | Short, descriptive |
| **Your user ID (UPN)** | `jdoe@company.com` | Your Azure AD user principal name |
| **Your email** | `jdoe@company.com` | Where alerts and notifications will be sent |
| **Subscription purpose** | `Prototyping an API gateway with Azure API Management and Function Apps` | 1-2 sentences |
| **Desired subscription name** | `sandbox-jdoe-api-gateway` | Must start with `sandbox-`. No spaces. |

### Optional Fields

| Field | Default | Notes |
|---|---|---|
| **Budget override** | $500/month | Provide justification if requesting more |
| **Additional tags** | — | e.g., `team=backend`, `cost-center=CC-1234` |
| **Workload type** | DevTest | Request `Production` only if DevTest offer restrictions affect your work |

---

## What Happens Next

1. The ops team reviews your ticket (typical SLA: 1 business day).
2. Ops provisions the subscription by running the vending pipeline — no manual portal steps.
3. You receive a confirmation email with:
   - Your subscription ID and name
   - Your expiry date (3 months from creation)
   - A link to the Azure portal
4. You can start using the subscription immediately.

---

## Requesting an Extension

If you need more time beyond the 3-month limit:

1. Open a **new ticket** with the title: `[Sandbox Extension] <subscription-name>`
2. Include your current subscription ID (visible in the Azure portal or in your confirmation email).
3. Provide a brief justification (1-2 sentences).

Extensions reset the expiry clock by an additional 90 days. Multiple extensions are possible but require justification.

---

## Requesting an Early Decommission

If you finish your work before expiry and want to release the resources:

Open a ticket with the title: `[Sandbox Decommission] <subscription-name>`.

Before ops runs the cleanup, you will have time to export any configurations you want to keep — see [How to Use Your Sandbox](./03-how-to-use.md#before-expiry).
