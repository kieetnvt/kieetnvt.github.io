---
layout: post
title: 'React Hooks vs Redux: So Sánh Quản Lý State Hiện Đại'
subtitle: Hiểu khi nào nên sử dụng React Hooks và Context API so với Redux
cover-img: "/assets/img/react-hooks-vs-redux-hooks-context-replace-redux.png"
thumbnail-img: "/assets/img/react-hooks-vs-redux-hooks-context-replace-redux.png"
share-img: "/assets/img/react-hooks-vs-redux-hooks-context-replace-redux.png"
tags:
- react
- redux
- hooks
- state-management
author: kieetnvt
lang: vi
ref: react-hooks-vs-redux
---

Quản lý state là một khía cạnh quan trọng của các ứng dụng React. Trong khi Redux đã là giải pháp quen thuộc trong nhiều năm, Context API và Hooks của React cung cấp các giải pháp thay thế tích hợp sẵn có thể đủ cho nhiều ứng dụng. Hãy cùng khám phá khi nào nên sử dụng mỗi cách tiếp cận.

### Quản Lý State trong React là gì?

Trong React, quản lý state trở nên cần thiết khi chúng ta cần chia sẻ dữ liệu giữa các components không kết nối. Không có giải pháp global state, các developers thường phải sử dụng prop drilling - truyền dữ liệu qua nhiều lớp components, dẫn đến:
- Code dư thừa
- Components nhận props mà chúng không sử dụng
- Giảm khả năng maintain
- Cấu trúc component phức tạp

### Cách Tiếp Cận với React Context API và Hooks

Context API kết hợp với Hooks (cụ thể là `useContext` và `useReducer`) cung cấp giải pháp tích hợp sẵn cho quản lý state. Đây là cách triển khai:

**1. Tạo Context**

```javascript
import { createContext, useReducer } from "react";

const initialState = {
  theme: "light"
};

const store = createContext(initialState);
const { Provider } = store;
```

**2. Thiết lập Provider với useReducer**

```javascript
const StateProvider = ({ children }) => {
  const [state, dispatch] = useReducer((state, action) => {
    switch(action.type) {
      case "TOGGLE_THEME":
        return {
          ...state,
          theme: state.theme === "light" ? "dark" : "light"
        };
      default:
        return state;
    }
  }, initialState);

  return <Provider value={{ state, dispatch }}>{children}</Provider>;
};
```

**3. Sử dụng Context trong Components**

```javascript
import { useContext } from 'react';
import { store } from './store';

const ThemeToggle = () => {
  const { state, dispatch } = useContext(store);

  return (
    <button onClick={() => dispatch({ type: "TOGGLE_THEME" })}>
      Current theme: {state.theme}
    </button>
  );
};
```

### Khi Nào Nên Sử Dụng Context + Hooks

1. **Ứng Dụng Nhỏ và Vừa**
   - Khi nhu cầu quản lý state của bạn tương đối đơn giản
   - Khi bạn không cần các tính năng nâng cao như time-travel debugging
   - Khi bạn muốn tránh các dependencies bên ngoài

2. **State Cụ Thể Cho Component**
   - Đối với state riêng biệt cho một tính năng hoặc cây component cụ thể
   - Khi các cập nhật state không thường xuyên
   - Khi bạn cần thiết lập nhanh với boilerplate tối thiểu

### Khi Nào Nên Sử Dụng Redux

1. **Ứng Dụng Lớn**
   - Yêu cầu quản lý state phức tạp
   - Nhiều cập nhật state xảy ra thường xuyên
   - Cần quản lý state tập trung

2. **Cần Các Tính Năng Nâng Cao**
   - Time-travel debugging
   - State persistence
   - Yêu cầu middleware phức tạp
   - Tối ưu hóa hiệu suất nâng cao

3. **Sở Thích Của Team**
   - Khi team đã quen thuộc với Redux
   - Cần các mẫu quản lý state chuẩn hóa
   - Team phát triển lớn làm việc trên cùng một codebase

### Redux Toolkit: Giải Pháp Redux Hiện Đại

Redux đã phát triển với Redux Toolkit, giải quyết nhiều vấn đề truyền thống về Redux:

1. **Giảm Boilerplate**

   ```javascript
   import { createSlice } from '@reduxjs/toolkit'

   const counterSlice = createSlice({
     name: 'counter',
     initialState: 0,
     reducers: {
       increment: state => state + 1,
       decrement: state => state - 1
     }
   })
   ```

2. **Immutability Tích Hợp Sẵn**
   - Viết logic "mutating" được chuyển thành các cập nhật immutable
   - Code reducer đơn giản hơn
   - Cập nhật state ít lỗi hơn

3. **Tích Hợp DevTools và Middleware**
   - Thiết lập Redux DevTools dễ dàng
   - Thunk middleware tích hợp sẵn
   - Cấu hình store đơn giản hơn

### Cân Nhắc Về Hiệu Suất

1. **Context API**
   - Re-render tất cả các components sử dụng context khi nó thay đổi
   - Tốt hơn cho các cập nhật không thường xuyên
   - Yêu cầu cấu trúc cẩn thận để tránh re-render không cần thiết

2. **Redux**
   - Connect HOC được tối ưu ngăn chặn re-render không cần thiết
   - Tốt hơn cho các cập nhật thường xuyên
   - Tối ưu hóa hiệu suất tích hợp sẵn

### Best Practices

1. **Bắt Đầu Đơn Giản**
   - Bắt đầu với local state
   - Chuyển sang Context API khi prop drilling trở thành vấn đề
   - Cân nhắc Redux khi bạn cần các tính năng nâng cao hơn

2. **Cấu Trúc State Của Bạn**
   - Giữ state tối thiểu và chuẩn hóa
   - Tách context providers theo domain
   - Cân nhậc các ảnh hưởng đến hiệu suất

3. **Tổ Chức Code**
   - Giữ logic liên quan đến state cùng nhau
   - Sử dụng các file riêng biệt cho các contexts/slices khác nhau
   - Tài liệu hóa các quyết định quản lý state của bạn

### So Sánh Context API và Redux

![alt text](../assets/img/context-redux.png)

### Kết Luận

Lựa chọn giữa Context API với Hooks của React và Redux không phải lúc nào cũng rõ ràng. Context với Hooks cung cấp giải pháp đơn giản hơn, tích hợp sẵn, hoàn hảo cho nhiều ứng dụng. Tuy nhiên, Redux (đặc biệt với Redux Toolkit) vẫn là lựa chọn mạnh mẽ cho các ứng dụng phức tạp yêu cầu các tính năng quản lý state nâng cao.

Cân nhắc nhu cầu của ứng dụng, chuyên môn của team, và các yêu cầu tương lai khi đưa ra quyết định này. Hãy nhớ rằng bạn cũng có thể sử dụng cả hai cách tiếp cận trong cùng một ứng dụng, sử dụng Context cho quản lý state đơn giản hơn và Redux cho các kịch bản phức tạp hơn.

Để biết thêm thông tin chi tiết, tham khảo:
- [Tài liệu Redux Toolkit](https://redux-toolkit.js.org/)
- [Tài liệu React Context](https://react.dev/reference/react/useContext)
- [React Hooks vs. Redux: Do Hooks and Context replace Redux?](https://blog.logrocket.com/react-hooks-vs-redux-hooks-context-replace-redux/)

