---
layout: post
title: "6 React Hooks Sẽ Thay Đổi Cách Bạn Viết React"
subtitle: "Hướng dẫn thực tế, dễ hiểu về các hooks bạn sẽ sử dụng hàng ngày — với những ví dụ thực tế, code sạch và không có thừa thãi"
cover-img: /assets/img/six-react-hooks-deep-dive.png
thumbnail-img: /assets/img/six-react-hooks-deep-dive.png
share-img: /assets/img/six-react-hooks-deep-dive.png
tags: [react, hooks, javascript, frontend, web-development]
author: kieetnvt
lang: vi
ref: six-react-hooks-deep-dive
---

Còn nhớ những ngày trước khi React Hooks ra mắt vào năm 2019 không? Quản lý state và side effects nghĩa là phải viết class components với các lifecycle methods dài dòng và vật lộn với việc binding `this`. Rồi Hooks xuất hiện và thay đổi tất cả! Đột nhiên, chúng ta có thể cắm logic có state trực tiếp vào function components — gọn gàng, dễ kết hợp và không còn rối rắm với `this` nữa.

Tuy nhiên, có một điều là: hooks có đường cong học tập nhất định, và điều này hoàn toàn bình thường! Ngay cả các developer giàu kinh nghiệm cũng phải vò đầu bứt tai với dependency array trong `useEffect`, tự hỏi khi nào `useMemo` thực sự giúp ích hay phản tác dụng, hoặc bối rối tại sao thay đổi `useRef` của họ không gây ra rerender. Nếu bạn đã từng cảm thấy như vậy, bạn hoàn toàn không đơn độc đâu.

Hướng dẫn này ở đây để giúp bạn thực sự hiểu các khái niệm này — hook này đến hook khác, khái niệm này đến khái niệm kia. Đến cuối bài, bạn sẽ cảm thấy thực sự tự tin khi sử dụng chúng, không chỉ là copy-paste code. Sẵn sàng chưa? Cùng bắt đầu thôi!

![Six react hooks](/assets/img/six-react-hooks-deep-dive.png "Six React Hooks")

## Nội Dung Chúng Ta Sẽ Tìm Hiểu

1. **useState** — lưu trữ và thay đổi giá trị
2. **useEffect** — đồng bộ với thế giới bên ngoài
3. **useRef** — một ngăn kéo không gây ra rerenders
4. **useCallback** — ghi nhớ functions giữa các renders
5. **useMemo** — cache các tính toán tốn kém
6. **useContext** — chia sẻ dữ liệu mà không cần prop drilling

---

## 01. useState — Lưu Trữ Giá Trị Thay Đổi Theo Thời Gian

### Vấn Đề Nó Giải Quyết

Giả sử bạn đang xây dựng một nút like. Khi ai đó click vào, icon sẽ được tô màu và số lượng like tăng lên. Đơn giản phải không? Nhưng đây là phần khó khăn: một biến JavaScript thông thường bên trong function sẽ reset mỗi lần function chạy. Và trong React, function chạy mỗi khi có thứ gì đó thay đổi. Vậy làm sao để nhớ bất cứ điều gì?

Đó chính là lý do `useState` ra đời! Nó cho bạn một giá trị tồn tại qua các renders, cộng với một cách tiện lợi để cập nhật nó, tự động kích hoạt React vẽ lại màn hình.

**Hãy nghĩ như thế này:** `useState` giống như một bảng trắng trong lớp học. Bạn viết gì đó lên đó, mọi người đều thấy. Khi bạn xóa và viết điều gì đó mới, mọi người thấy cập nhật ngay lập tức. Bảng trắng không bị reset về trống mỗi khi học sinh giơ tay — nó tồn tại! Đó chính là cách `useState` hoạt động cho component của bạn.

### Cách Nó Hoạt Động

`useState` cho bạn hai thứ: giá trị hiện tại và một setter function. Bạn gọi setter với giá trị mới, React re-render, và bây giờ component có giá trị đã cập nhật — không cần thao tác DOM thủ công.

```javascript
import { useState } from 'react';

function LikeButton() {
  // [giáTrịHiệnTại, hàmSetter] = useState(giáTrịKhởiTạo)
  const [likes, setLikes] = useState(0);
  const [liked, setLiked] = useState(false);

  function handleClick() {
    if (liked) {
      setLikes(likes - 1);
      setLiked(false);
    } else {
      setLikes(likes + 1);
      setLiked(true);
    }
  }

  return (
    <button onClick={handleClick} style={{ color: liked ? 'red' : 'gray' }}>
      {liked ? '❤️' : '🤍'} {likes}
    </button>
  );
}
```

### Pattern Cập Nhật Functional

Đây là một mẹo nhỏ sẽ giúp bạn tránh được nhiều vấn đề sau này: khi state mới phụ thuộc vào state cũ, đừng sử dụng giá trị hiện tại trực tiếp. Thay vào đó, truyền một function cho setter. Điều này đảm bảo bạn luôn làm việc với giá trị mới nhất, ngay cả trong các trường hợp async phức tạp.

```javascript
// ❌ Có thể lỗi thời — đọc `count` từ closure
setCount(count + 1);

// ✅ Luôn chính xác — React truyền giá trị mới nhất
setCount(prev => prev + 1);
```

### Khi Nào Nên Dùng

- Giá trị thay đổi theo thời gian và UI cần phản ánh sự thay đổi đó
- Theo dõi form inputs, toggle states, counters
- Lưu trữ dữ liệu fetch hoặc UI state (mở/đóng, tab được chọn)

### Khi Nào KHÔNG Nên Dùng

- Giá trị không ảnh hưởng đến UI (dùng `useRef` thay thế)
- Giá trị dẫn xuất — tính toán inline thay vì lưu trữ
- Bạn cần shared state sâu (cân nhắc `useContext` hoặc state manager)

**⚠️ Lưu ý!** Cập nhật state không xảy ra ngay lập tức. Sau khi gọi `setCount(5)`, nếu bạn đọc `count` ở dòng tiếp theo, bạn vẫn sẽ nhận được giá trị cũ. Tại sao? Vì React lên lịch cập nhật và gộp chúng lại để tối ưu hiệu năng. Nếu bạn cần làm gì đó với giá trị mới, nơi phù hợp là ở lần render tiếp theo (hoặc trong `useEffect` nếu bạn cần phản ứng với sự thay đổi).

---

## 02. useEffect — Đồng Bộ Component Với Thế Giới Bên Ngoài

### Vấn Đề Nó Giải Quyết

Công việc của React là render UI từ state — đó là điều nó làm! Nhưng các ứng dụng thực tế cần làm nhiều hơn chỉ rendering. Bạn cần fetch dữ liệu từ APIs, thiết lập WebSockets, bắt đầu timers, subscribe các browser events... danh sách còn dài. Những thứ này được gọi là **side effects**, và chúng cần một nơi an toàn, được chỉ định để tồn tại.

Đó là lúc `useEffect` xuất hiện! Nó chạy sau khi React đã vẽ màn hình, nên nó không bao giờ chặn render của bạn. Hãy nghĩ về nó như React đang nói: "Okay, tôi đã vẽ xong mọi thứ rồi — bây giờ bạn có thể làm việc external của mình!"

**Ví dụ thực tế:** Hãy tưởng tượng bạn chuyển vào một căn hộ mới (component mounts). Việc đầu tiên bạn làm? Gọi nhà cung cấp internet để cài đặt Wi-Fi (effect). Khi bạn chuyển đi (component unmounts), bạn hủy dịch vụ (cleanup function). Và nếu bạn chuyển sang một unit khác với gói khác (dependency changes), bạn hủy hợp đồng cũ và thiết lập một cái mới. Đó là lifecycle của `useEffect` trong một tình huống thực tế!

### Cấu Trúc của useEffect

`useEffect` nhận hai đối số: một function (effect) và một dependency array tùy chọn. Dependency array là phần quan trọng nhất — nó kiểm soát khi nào effect chạy.

```javascript
import { useState, useEffect } from 'react';

function UserProfile({ userId }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false; // ngăn stale state khi switch nhanh

    setLoading(true);
    fetch(`/api/users/${userId}`)
      .then(res => res.json())
      .then(data => {
        if (!cancelled) {
          setUser(data);
          setLoading(false);
        }
      });

    // Cleanup: chạy trước effect tiếp theo HOẶC khi unmount
    return () => {
      cancelled = true;
    };
  }, [userId]); // Chạy lại khi userId thay đổi

  if (loading) return <p>Đang tải...</p>;
  return <h1>{user?.name}</h1>;
}
```

### Dependency Array — Hiểu Đúng Phần Này

Dependency array nói với React khi nào chạy lại effect. Có ba dạng:

```javascript
// 1. Không có array → chạy sau MỌI render (thường là sai)
useEffect(() => { ... });

// 2. Array rỗng → chỉ chạy MỘT LẦN khi mount
useEffect(() => { ... }, []);

// 3. Có deps → chạy khi bất kỳ giá trị nào được liệt kê thay đổi
useEffect(() => { ... }, [userId, searchQuery]);
```

### Khi Nào Nên Dùng

- Fetch dữ liệu khi component mount hoặc prop thay đổi
- Thiết lập subscriptions (WebSockets, event listeners)
- Đồng bộ state với localStorage hoặc external stores
- Bắt đầu/xóa timers và intervals

### Khi Nào KHÔNG Nên Dùng

- Bạn chỉ cần giá trị dẫn xuất — tính toán inline
- Phản hồi event của user — dùng event handler trực tiếp
- Cập nhật state dựa trên state (có thể gây render loops)

**⚠️ Coi chừng bẫy vòng lặp vô hạn!** Đây là lỗi #1 với `useEffect`, và tất cả chúng ta đều từng mắc phải. Setting state trong effect mà không có dependency array đúng sẽ tạo ra vòng lặp bất tận: effect chạy → set state → component re-render → effect chạy lại → lặp lại mãi mãi. Ôi trời! Luôn kiểm tra kỹ dependency array của bạn và tránh include những thứ thay đổi mỗi render (như inline objects hoặc functions).

**💡 Lời khuyên hữu ích:** Hãy tạo thói quen viết cleanup functions, ngay cả khi bạn nghĩ mình không cần chúng. Tin tôi đi, chúng sẽ cứu bạn khỏi những bugs khó tìm xuất hiện khi components unmount bất ngờ. Thêm nữa, Strict Mode của React (cố ý mount/unmount components hai lần trong development) sẽ cảm ơn bạn vì điều này!

---

*[Tiếp tục với các hooks còn lại...]*

## Bạn Đã Hiểu Rồi Đấy!

Và đó là tất cả! Sáu hooks này là nền tảng của hầu hết mọi React component bạn sẽ viết. Đây là bảng tham khảo nhanh cho bạn:

| Hook | Công dụng |
|------|-----------|
| `useState` | Lưu trữ giá trị thay đổi và điều khiển UI updates |
| `useEffect` | Đồng bộ với thế giới bên ngoài sau renders |
| `useRef` | Lưu giá trị hoặc lấy DOM nodes mà không gây rerenders |
| `useCallback` | Memoize functions để có stable child prop references |
| `useMemo` | Cache các tính toán tốn kém giữa các renders |
| `useContext` | Chia sẻ dữ liệu globally mà không cần prop drilling |

Cách tốt nhất để thực sự nắm vững tất cả những điều này? Xây dựng một thứ gì đó! Bắt đầu với một tính năng nhỏ và từ từ mở rộng. Mỗi bug bạn gặp — dù là thiếu dependency hay vòng lặp vô hạn — sẽ dạy bạn nhiều hơn bất kỳ bài viết nào. Đó là cách tất cả chúng ta đã học!

Bây giờ bạn đã có đầy đủ kiến thức cần thiết. Hãy tiến lên và xây dựng một thứ gì đó tuyệt vời! 🚀

**Chúc bạn code vui vẻ!**
