---
layout: post
title: 7 Pattern Coding Tôi Học Từ Senior Engineers
subtitle: Những thói quen thực tế giúp code dễ đọc, dễ sửa, dễ debug và dễ review hơn
cover-img: /assets/img/readablecode.jpg
thumbnail-img: /assets/img/readablecode.jpg
share-img: /assets/img/readablecode.jpg
tags: [coding, software-development, software-engineering, clean-code, programming, vietnamese]
author: kieetnvt
lang: vi
ref: 7-coding-patterns-i-stole-from-senior-engineers
---

Phần lớn developer không giỏi hơn chỉ vì họ học thêm nhiều cú pháp.

Họ giỏi hơn vì họ ngừng làm code khó hơn mức cần thiết.

Trước đây tôi nghĩ clean code là code trông thật thanh lịch. Sau đó tôi làm việc với những engineer đã từng kéo hệ thống thật qua production incidents, migrations khó chịu, ownership không rõ ràng, và những codebase không ai muốn đụng vào. Code của họ không hào nhoáng. Không đầy abstraction thông minh. Thường còn khá boring.

Nhưng khi requirement đổi, code của họ vẫn sống sót.

Đó là lúc tôi bắt đầu chú ý.

Những pattern hay nhất tôi học được từ senior engineers không phụ thuộc framework. Chúng là judgment patterns: cách viết code giúp bug dễ tìm hơn, thay đổi dễ thực hiện hơn, và hệ thống khó bị hiểu sai hơn.

Đây là bảy pattern như vậy.

## 1. Return early thay vì tạo mê cung điều kiện

Pattern đầu tiên rất đơn giản: xử lý các failure path trước khi vào logic chính.

Nested condition quá sâu buộc người đọc phải giữ quá nhiều trạng thái trong đầu. Guard clauses làm các điều kiện dừng trở nên rõ ràng và giữ happy path dễ đọc.

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

So với phiên bản giấu intent trong nhiều tầng `if`:

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

Phiên bản nested có thể trông vô hại lúc đầu. Rồi ai đó thêm account status check, organization permission, email verification, audit logging, và feature flag. Bây giờ function trở nên khó scan trong lúc incident.

Return early khi các failure condition độc lập và dễ gọi tên.

Takeaway: loại bỏ bad paths sớm để logic chính có không gian thở.

## 2. Đặt tên theo business meaning, không theo chi tiết kỹ thuật

Tên kém không chỉ là vấn đề thẩm mỹ. Nó tạo thêm công việc debug.

Những tên như `data`, `result`, `payload`, `item`, và `response` cho biết shape kỹ thuật, nhưng không nói ý nghĩa thật.

~~~typescript
const result = await getData(id);

if (result.status === 'active') {
  await process(result);
}
~~~

Phiên bản này mang nhiều ý nghĩa hơn:

~~~typescript
const subscription = await getSubscription(subscriptionId);

if (subscription.isBillable) {
  await chargeSubscription(subscription);
}
~~~

Phiên bản thứ hai nói cho developer tiếp theo biết điều gì quan trọng. Đây là một subscription. Điều kiện quan trọng không phải status chung chung, mà là subscription có thể được billing hay không.

Tên dài không tự động là xấu. Đôi khi business rule rất cụ thể, và tên cũng nên cụ thể.

~~~typescript
const usersEligibleForReactivation = await findUsersEligibleForReactivation();
~~~

Dùng tên ngắn cho giá trị local thật sự hiển nhiên. Dùng business name cho các khái niệm có rủi ro sản phẩm.

Takeaway: đặt tên để developer tiếp theo không phải reverse-engineer intent từ implementation.

## 3. Đặt boundary quanh sự hỗn loạn bên ngoài

External systems không bao giờ luôn lịch sự.

API thay đổi. Webhook đến trễ. Field bên thứ ba biến mất. Payment provider trả về edge case. Date format không nhất quán. Nếu raw external shape bị leak khắp nơi, vendor sẽ trở thành một phần architecture nội bộ của bạn.

Đoạn này mong manh:

~~~typescript
const userName = response.data.user_name;
const isActive = response.data.status === 'ACTIVE';
const plan = response.data.subscription.plan_name;
~~~

Tạo boundary thay vào đó:

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

Phần còn lại của hệ thống không cần biết vendor gọi field là `user_name`, `customerName`, hay `profile.display_name`. Application nên nhận shape do team bạn sở hữu.

Pattern này không chỉ áp dụng cho API:

- Đừng để raw database rows leak vào UI logic.
- Đừng để HTTP response shapes leak vào domain logic.
- Đừng để framework request objects leak vào business services.
- Đừng parse environment variables rải rác trong nhiều file.

Boundary có chi phí. Không cần tạo mapping layer cho mọi script nhỏ. Nhưng khi external data đi qua nhiều feature, containment sẽ rất đáng giá.

Takeaway: đừng để hệ thống bạn không kiểm soát định nghĩa shape của hệ thống bạn kiểm soát.

## 4. Làm invalid states khó tồn tại

Optional fields ở khắp nơi không phải type safety. Thường đó là dấu hiệu model quá mơ hồ.

~~~typescript
type User = {
  id?: string;
  email?: string;
  role?: string;
  status?: string;
};
~~~

Kiểu này buộc mọi caller phải hỏi những câu lo lắng:

- User này có ID chưa?
- Email có tồn tại không?
- Role có hợp lệ không?
- User này có thể lưu được chưa?
- User này có thể hiển thị được không?

Hãy model trạng thái thật:

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

Draft user không phải saved user. Pending payment không phải captured payment. Cart không phải submitted order. Code an toàn hơn khi các khác biệt đó rõ ràng.

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

Ý tưởng này không chỉ dành cho TypeScript. Với dynamic languages, bạn có thể dùng validation, constructors, schemas, factories, hoặc runtime checks rõ ràng.

Takeaway: đừng chỉ handle invalid states. Hãy thiết kế để invalid states có ít nơi ẩn náu hơn.

## 5. Tách decisions khỏi actions

Business decisions dễ tin hơn khi có thể test mà không kích hoạt side effects.

Function này trộn refund rules với database calls, payment provider calls, và email:

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

Kéo phần decision ra một pure function:

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

Sau đó giữ side effects trong action:

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

Bây giờ refund rules có thể được test mà không cần mock payment provider, database, hoặc email service.

Dùng pattern này cho permission checks, pricing rules, validation, workflow transitions, retry decisions, notification rules, và scheduling logic.

Takeaway: decisions nên dễ test mà không trigger side effects mà chúng kiểm soát.

## 6. Làm errors hữu ích cho người tiếp theo

Error message như thế này gần như không giao tiếp được gì:

~~~json
{
  "message": "Something went wrong"
}
~~~

Nó không giúp user, support, frontend, backend engineer, hay người đang on-call.

API error tốt hơn nên có stable fields cho hệ thống và đủ context cho con người:

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

Text dành cho con người. Codes dành cho hệ thống.

Tránh frontend logic parse prose:

~~~typescript
if (error.message.includes('already exists')) {
  showEmailTakenError();
}
~~~

Đoạn code này vỡ khi backend đổi wording, localization đổi copy, hoặc endpoint khác trả về text tương tự.

Structured logs cũng quan trọng:

~~~typescript
logger.warn('Refund rejected', {
  invoiceId,
  customerId,
  reason: eligibility.reason,
  requestId
});
~~~

Đừng log secrets, tokens, passwords, payment details, hoặc sensitive personal data. Hãy log safe identifiers, request IDs, và structured reasons để failure có thể trace được.

Takeaway: errors nên giúp người tiếp theo hiểu cái gì fail, fail ở đâu, và bằng chứng nào nối failure đó lại.

## 7. Tối ưu cho diff, không chỉ demo

Một feature có thể chạy hoàn hảo trong demo nhưng vẫn nguy hiểm để merge.

Code có thể chạm quá nhiều khu vực. Diff có thể trộn refactor với behavior changes. Tests có thể chỉ cover happy path. Migration có thể bị giấu trong cleanup không liên quan. Rollback path có thể không rõ.

Demo chạy.

Hệ thống trở nên rủi ro hơn.

Senior engineers nghĩ theo diff vì diff là cách team hấp thụ thay đổi.

Pull request này khó review:

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

Chuỗi PR này dễ review hơn và an toàn hơn khi rollback:

~~~text
PR 1: Rename payment fields without behavior changes
PR 2: Add refund eligibility helper with tests
PR 3: Wire refund eligibility into billing flow
PR 4: Update dashboard UI to show refund reason
PR 5: Add webhook retry behavior
~~~

Cách này có vẻ chậm hơn nếu bạn chỉ tính thời gian gõ code. Nó nhanh hơn nếu tính review, debugging, rollback, và trust.

Takeaway: code chưa xong chỉ vì nó chạy trên máy bạn. Nó xong khi thay đổi đó dễ hiểu, dễ review, có test, và an toàn để undo.

## Pattern nằm dưới các pattern

Bảy pattern này trông khác nhau:

- Guard clauses
- Tên tốt hơn
- Boundaries
- States an toàn hơn
- Decisions tách khỏi actions
- Errors hữu ích
- Diffs dễ review

Nhưng bên dưới, tất cả đều giảm surprise.

Senior engineers không dị ứng với complexity. Họ biết complexity phải sống ở đâu đó. Nếu nó không nằm trong tên rõ ràng, boundary rõ ràng, model trung thực, function tập trung, errors hữu ích, và diff nhỏ, nó sẽ lan vào đầu mọi người.

Đó là nơi software trở nên mệt mỏi.

Good code không phải code chứng minh bạn biết nhiều đến đâu.

Good code là code cho developer tiếp theo ít lý do hơn để phải đoán.
