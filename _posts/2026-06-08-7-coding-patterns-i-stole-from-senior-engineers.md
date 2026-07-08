---
layout: post
title: 7 Coding Patterns I Stole From Senior Engineers
subtitle: Practical habits that make code easier to read, change, debug, and review
cover-img: /assets/img/readablecode.jpg
thumbnail-img: /assets/img/readablecode.jpg
share-img: /assets/img/readablecode.jpg
tags: [coding, software-development, software-engineering, clean-code, programming]
author: kieetnvt
---

Most developers do not become better only because they learn more syntax.

They become better because they stop making code harder than it needs to be.

I used to think clean code meant elegant code. Then I worked with engineers who had carried real systems through production incidents, awkward migrations, unclear ownership, and codebases nobody wanted to touch. Their code was not flashy. It was not full of clever abstractions. It was often boring.

Then the requirements changed, and their code survived.

That is when I started paying attention.

The best patterns I learned from senior engineers were not framework-specific. They were judgment patterns: ways of writing code that made bugs easier to find, changes easier to make, and systems harder to misunderstand.

Here are seven of them.

## 1. Return Early Instead of Building Conditional Mazes

The first pattern is simple: remove failure paths before the main logic.

Deep nesting forces readers to hold too much state in their head. Guard clauses make the stop conditions visible and keep the happy path readable.

~~~typescript
async function updateUserProfile(userId: string, input: ProfileInput) {
  const user = await getUser(userId);

  if (!user) {
    throw new NotFoundError('User not found');
  }

  if (!input.email) {
    throw new ValidationError('Email is required');
  }

  if (!user.canEditProfile) {
    throw new ForbiddenError('User cannot edit profile');
  }

  return saveProfile(user.id, input);
}
~~~

Compare that with the version that hides intent inside nested branches:

~~~typescript
async function updateUserProfile(userId: string, input: ProfileInput) {
  const user = await getUser(userId);

  if (user) {
    if (input.email) {
      if (user.canEditProfile) {
        return saveProfile(user.id, input);
      }
    }
  }

  throw new Error('Unable to update profile');
}
~~~

The nested version may look harmless at first. Then someone adds account status checks, organization permissions, email verification, audit logging, and feature flags. Now the function is difficult to scan during an incident.

Return early when the failure conditions are independent and easy to name.

Takeaway: remove bad paths early so the real logic can breathe.

## 2. Name the Business Meaning, Not the Technical Accident

Bad names are not cosmetic. They create debugging work.

Names like `data`, `result`, `payload`, `item`, and `response` tell the reader what shape something has, not what it means.

~~~typescript
const result = await getData(id);

if (result.status === 'active') {
  await process(result);
}
~~~

This version carries more meaning:

~~~typescript
const subscription = await getSubscription(subscriptionId);

if (subscription.isBillable) {
  await chargeSubscription(subscription);
}
~~~

The second version tells the next developer what matters. This is a subscription. The important condition is not a generic status check. It is whether the subscription can be billed.

Long names are not automatically bad. Sometimes the business rule is specific, and the name should be specific too.

~~~typescript
const usersEligibleForReactivation = await findUsersEligibleForReactivation();
~~~

Use short names for truly local, obvious values. Use business names for concepts that carry product risk.

Takeaway: name code so the next developer does not have to reverse-engineer intent from implementation.

## 3. Put Boundaries Around External Chaos

External systems do not stay polite.

APIs change. Webhooks arrive late. Third-party fields disappear. Payment providers return edge cases. Date formats become inconsistent. If raw external shapes leak everywhere, the vendor becomes part of your internal architecture.

This is fragile:

~~~typescript
const userName = response.data.user_name;
const isActive = response.data.status === 'ACTIVE';
const plan = response.data.subscription.plan_name;
~~~

Create a boundary instead:

~~~typescript
function mapBillingCustomer(response: BillingCustomerResponse): Customer {
  return {
    id: response.id,
    name: response.user_name,
    isBillable: response.status === 'ACTIVE',
    planName: response.subscription?.plan_name ?? 'Free'
  };
}
~~~

The rest of the system should not care whether the vendor calls a field `user_name`, `customerName`, or `profile.display_name`. Your application should receive a shape your team owns.

This applies beyond APIs:

- Do not let raw database rows leak into UI logic.
- Do not let HTTP response shapes leak into domain logic.
- Do not let framework request objects leak into business services.
- Do not parse environment variables randomly across files.

Boundaries have a cost. They are not necessary for every tiny script. But once external data crosses multiple features, containment pays for itself.

Takeaway: never let systems you do not control define the shape of systems you do control.

## 4. Make Invalid States Hard to Represent

Optional fields everywhere are not type safety. They are often a sign that the model is too vague.

~~~typescript
type User = {
  id?: string;
  email?: string;
  role?: string;
  status?: string;
};
~~~

This forces every caller to ask anxious questions:

- Does this user have an ID?
- Is the email defined?
- Is the role valid?
- Can this user be saved?
- Can this user be displayed?

Model real states instead:

~~~typescript
type DraftUser = {
  email: string;
  role: 'admin' | 'member';
};

type SavedUser = {
  id: string;
  email: string;
  role: 'admin' | 'member';
  status: 'active' | 'disabled';
};
~~~

A draft user is not a saved user. A pending payment is not a captured payment. A cart is not a submitted order. Code becomes safer when those differences are explicit.

~~~typescript
type Payment =
  | { state: 'pending'; id: string }
  | { state: 'authorized'; id: string; authorizationId: string }
  | { state: 'captured'; id: string; receiptId: string }
  | { state: 'failed'; id: string; reason: string };

function sendReceipt(payment: Extract<Payment, { state: 'captured' }>) {
  return emailReceipt(payment.receiptId);
}
~~~

This idea is not limited to TypeScript. In dynamic languages, you can use validation, constructors, schemas, factories, or clear runtime checks.

Takeaway: do not just handle invalid states. Design code so invalid states have fewer places to hide.

## 5. Separate Decisions From Actions

Business decisions are easier to trust when they can be tested without triggering side effects.

This function mixes refund rules with database calls, payment provider calls, and email:

~~~typescript
async function refundInvoice(invoiceId: string) {
  const invoice = await getInvoice(invoiceId);

  if (invoice.status !== 'paid') {
    throw new Error('Invoice cannot be refunded');
  }

  if (invoice.refundedAt) {
    throw new Error('Invoice already refunded');
  }

  if (invoice.amount <= 0) {
    throw new Error('Invalid refund amount');
  }

  await paymentProvider.refund(invoice.paymentId);
  await markInvoiceRefunded(invoice.id);
  await sendRefundEmail(invoice.customerId);
}
~~~

Pull the decision into a pure function:

~~~typescript
function getRefundEligibility(invoice: Invoice): RefundEligibility {
  if (invoice.status !== 'paid') {
    return { allowed: false, reason: 'Invoice is not paid' };
  }

  if (invoice.refundedAt) {
    return { allowed: false, reason: 'Invoice is already refunded' };
  }

  if (invoice.amount <= 0) {
    return { allowed: false, reason: 'Invalid refund amount' };
  }

  return { allowed: true };
}
~~~

Then keep the side effects in the action:

~~~typescript
async function refundInvoice(invoiceId: string) {
  const invoice = await getInvoice(invoiceId);
  const eligibility = getRefundEligibility(invoice);

  if (!eligibility.allowed) {
    throw new ValidationError(eligibility.reason);
  }

  await paymentProvider.refund(invoice.paymentId);
  await markInvoiceRefunded(invoice.id);
  await sendRefundEmail(invoice.customerId);
}
~~~

Now the refund rules can be tested without mocking the payment provider, database, or email service.

Use this pattern for permission checks, pricing rules, validation, workflow transitions, retry decisions, notification rules, and scheduling logic.

Takeaway: decisions should be easy to test without triggering the side effects they control.

## 6. Make Errors Useful to the Next Person

An error message like this is barely communication:

~~~json
{
  "message": "Something went wrong"
}
~~~

It does not help the user, support, the frontend, the backend engineer, or the person on call.

A stronger API error gives systems stable fields and people enough context:

~~~json
{
  "code": "USER_EMAIL_ALREADY_EXISTS",
  "message": "A user with this email already exists.",
  "details": {
    "field": "email"
  },
  "requestId": "req_8f91a2"
}
~~~

Text is for humans. Codes are for systems.

Avoid frontend logic that parses prose:

~~~typescript
if (error.message.includes('already exists')) {
  showEmailTakenError();
}
~~~

That code breaks when the backend changes wording, localization changes copy, or another endpoint returns similar text.

Structured logs matter too:

~~~typescript
logger.warn('Refund rejected', {
  invoiceId,
  customerId,
  reason: eligibility.reason,
  requestId
});
~~~

Do not log secrets, tokens, passwords, payment details, or sensitive personal data. Do log safe identifiers, request IDs, and structured reasons that make a failure traceable.

Takeaway: errors should help the next person understand what failed, where it failed, and what evidence connects the failure.

## 7. Optimize for the Diff, Not the Demo

A feature can work perfectly in a demo and still be dangerous to merge.

The code may touch too many areas. The diff may mix refactoring with behavior changes. Tests may cover only the happy path. A migration may be hidden inside unrelated cleanup. The rollback path may be unclear.

The demo works.

The system gets riskier.

Senior engineers think in diffs because diffs are how teams absorb change.

This pull request is hard to review:

~~~text
feat: update billing flow
- refactor invoice service
- rename payment fields
- update refund logic
- change dashboard UI
- add new webhook handler
- modify retry behavior
- fix customer status bug
- update tests
~~~

This sequence is easier to review and safer to roll back:

~~~text
PR 1: Rename payment fields without behavior changes
PR 2: Add refund eligibility helper with tests
PR 3: Wire refund eligibility into billing flow
PR 4: Update dashboard UI to show refund reason
PR 5: Add webhook retry behavior
~~~

It can feel slower if you only count typing. It is faster when you count review, debugging, rollback, and trust.

Takeaway: code is not done when it works locally. It is done when the change is understandable, reviewable, testable, and safe to undo.

## The Pattern Under the Patterns

These seven patterns look different:

- Guard clauses
- Better names
- Boundaries
- Safer states
- Separated decisions
- Useful errors
- Reviewable diffs

Underneath, they all reduce surprise.

Senior engineers are not allergic to complexity. They know complexity has to live somewhere. If it does not live in clear names, explicit boundaries, honest models, focused functions, useful errors, and small diffs, it spreads into people's heads.

That is where software becomes exhausting.

Good code is not code that shows how much you know.

Good code is code that gives the next developer fewer reasons to guess.
