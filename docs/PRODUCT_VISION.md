# CallCare — Product Vision & Business Context

> **Read this before building features.** It explains *why* this app exists, who it serves,
> and where the current build diverges from the founding vision. Technical setup lives in
> the other docs; this is the business brain.

## The founding insight

Ulaanbaatar's reality:

- **Traffic** makes any hospital trip a half-day commitment.
- **Hospitals are overloaded** — queues, stress, exposure.
- A large class of medical needs is **real but not ambulance-critical**: IV drips
  ("Дусал залгах") after days of drinking, injections, post-op care, elder check-ups,
  children's sample collection, chronic-condition monitoring.
- Today this demand is served through **Facebook groups**: people literally post
  *"Хан-Уул орчимд дусал залгах сувилагч байна уу?"* and wait for DMs. No vetting,
  no pricing, no accountability, no supplies guarantee — but it proves the demand
  exists and is urgent, recurring, and willing to pay.

**CallCare replaces that Facebook post** with a verified, supplied, accountable
professional arriving at home — at the right time, in the right district.

## What CallCare actually is (the whole system)

Not "a booking app." Four interlocking parts:

1. **Patient app** (Flutter) — request a treatment or lab collection at home;
   scheduled or as-soon-as-possible.
2. **Provider network** — nurses, doctors, lab technicians (`doctor_type` enum:
   `nurse | general | lab_technician | diagnostic_specialist`) who roam the city
   and accept nearby requests. Verified by admin (license check).
3. **Supply chain — the moat.** Providers receive consumables (IV kits, needles,
   systems, collection tubes) **from CallCare**, not on their own. This is:
   - **anti-leakage**: a provider who takes a patient off-platform loses resupply;
   - **quality control**: standardized, traceable materials;
   - **margin**: supplies are a second revenue line besides commission.
   *Status: not yet modeled in software — see Gap list.*
4. **Partner labs & hospitals** — samples collected at home are delivered to partner
   laboratories; results flow back. Hospitals are a referral channel both ways.

## The two demand curves (one provider pool)

| | Scheduled lab collection | Urgent home treatment |
|---|---|---|
| Example | CBC panel for diabetic mother, Tuesday 9:00 | IV drip for dehydration, *tonight, now* |
| Buyer | Often a family member booking **for someone else** | Often the patient, sometimes impaired |
| When | Daytime, planned | Evenings, nights, weekends |
| Payment | Invoice-friendly (QPay or transfer) | **Prepay mandatory** (filters pranks, protects providers) |
| Match logic | Time-slot scheduling | **Proximity + speed** (district first, minutes matter) |
| Status flow | pending → accepted → on_the_way → sample_collected → delivered_to_lab → completed | pending → accepted → on_the_way → (treatment) → completed |

The same nurse serves both: lab rounds by day, treatment calls by night. Utilization
is the business model.

## Who the actors are and how they interact

```
Patient/Family ──request──▶ CallCare matching ──notify──▶ Nearby available providers
      ▲                            │                              │ accept
      │   notifications,           │ no match in ~10 min?         ▼
      │   status updates           ├──▶ escalate to admin   Provider travels (kit from CallCare)
      │                            ▼                              │
      └──── results / receipt ◀── Lab partner ◀── sample ◀── visit happens
                                                              │ treatment? → done on site
                                            payment: QPay prepay / verified transfer
                                            review: patient rates provider
```

- **Admin (admin-web/)** verifies providers, reviews manual payments, cancels stuck
  requests, resets passwords, watches revenue. The escalation human when matching fails.
- **CallCare ops** (future module) issues supply kits, tracks consumables per visit,
  restocks providers, settles commissions.

## Honest gap analysis (June 2026)

What the current build serves well: **scheduled lab collection with verified doctors,
QPay/manual payments, full status tracking, bilingual notifications, admin operations.**

What the founding use case still needs — ranked:

1. **Treatment service catalog.** The services table has 116 entries, all lab/imaging.
   "Дусал залгах", injections, nursing care **do not exist** → the killer use case
   cannot be ordered. Add a "Home Treatment / Эмчилгээ" category with the top
   Facebook-demand services, nurse-deliverable, fixed transparent prices + night surcharge.
2. **ASAP mode.** `scheduled_date` is required — there is no "come now". Need an
   urgency flag (`asap`), ETA communication, and a 10-minute no-acceptance escalation
   (admin alerted, patient told honestly).
3. **Proximity matching.** Requests fan out citywide; patient lat/lng is stored but
   unused. V1: match by district (дүүрэг) — that's how people already think
   ("Khan-Uul орчимд"). Later: radius + provider live location.
4. **Beneficiary booking.** Requests bind to the account holder, but elders and
   children — two of the three named target groups — don't have accounts. Need
   "booking for: name / age / relation / allergies" on the request.
5. **2-minute signup.** Registration currently demands citizenship status, registration
   number, permanent address. A patient at 23:30 will not complete it. Minimum: phone +
   password (+ later SMS OTP); everything else collected at first booking or later.
6. **Supply/kit module.** Nothing models kits, consumables, or stock. Even a minimal
   ledger (kit assigned to provider, consumables per completed visit, restock alert)
   unlocks the moat and the second revenue line. Admin CMS phase.
7. **Provider safety policy** (product + ops, not just code): prepay-only for
   intoxication-related night calls, free decline, patient history visible before
   accept, in-app emergency contact, night-shift opt-in.

## Edge cases that kill similar businesses (policy decisions)

| Edge case | Policy |
|---|---|
| Off-platform leakage (provider takes patient private) | Supply lock-in + commission worth paying (speed of next job > 10–15% fee) |
| Prank / fake bookings at night | Prepay mandatory for ASAP; no prepay → no dispatch |
| Provider no-show / cancel after accept | Auto-return request to pool + admin alert + provider strike system |
| Patient door unanswered | Provider waits 15 min, photographs arrival, gets travel compensation from prepayment |
| On-site scope change ("also treat my wife") | Add-service flow at fixed catalog prices; never freelance pricing |
| Medical emergency during visit | Provider protocol: call 103, stay until handover; CallCare is *not* emergency care and says so everywhere |
| Allergic reaction risk (IV at home) | Intake questions on booking (allergies field exists), contraindication checklist per service, provider can refuse on clinical grounds without penalty |
| Bad/defamatory review | Admin moderation via `doctor_reviews.is_visible` (admin UI pending) |
| Paid then cancelled | Refund policy + "mark refunded" trail (pending) |

## Growth (how it becomes "instantly install")

- **The pitch:** «Дусал, тариа, шинжилгээ — гэртээ. Facebook-ээр сувилагч хайх хэрэггүй.»
- **Distribution is already concentrated:** the Facebook groups themselves. Answer
  posts, run targeted content there, convert the exact moment of need.
- **The first urgent request must succeed:** install → request < 2 min, match < 10 min,
  or the user returns to Facebook forever.
- **Built-in loops:** providers recruit patients ("book me on CallCare next time" —
  they want repeat business); families book for parents (one install serves a household);
  the visit itself is the marketing (verified, uniformed, supplied professional at your
  door is a story people tell).
- **Trust artifacts:** license badge, real reviews, fixed prices, receipts (Ebarimt
  integration planned — see docs/2026.3.17 V2 API with Ebarimt 3.0).

## Current implementation status (snapshot June 2026)

- ✅ Patient + doctor Flutter apps (scheduled flows), Supabase backend with RLS,
  status machine, bilingual notifications, QPay + manual payments, reviews, posts,
  AI chat edge function
- ✅ Admin web (admin-web/): dashboards, doctor lifecycle management, manual payment
  review, request intervention, password resets
- ⏳ Push delivery: wired end-to-end, blocked only on FCM service-account secrets
- ⏳ Auth: phone-as-email + password; no OTP, no self-service recovery (admin resets)
- ❌ Items 1–7 in the gap list above

*Keep this doc updated when the gap list changes — it is the source of truth for
"what should be built next and why."*
