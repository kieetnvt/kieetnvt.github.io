---
layout: post
title: 'React Hooks Cheat Sheet: Best Practices và Giải Pháp Phổ Biến'
subtitle: Hướng dẫn toàn diện về React Hooks với các ví dụ thực tế
cover-img: "/assets/img/react-hooks-cheat-sheet-solutions-common-problems.png"
thumbnail-img: "/assets/img/react-hooks-cheat-sheet-solutions-common-problems.png"
share-img: "/assets/img/react-hooks-cheat-sheet-solutions-common-problems.png"
tags:
- react
- hooks
- javascript
- frontend
author: kieetnvt
lang: vi
ref: react-hooks-cheat-sheet
---

React Hooks đã cách mạng hóa việc quản lý state và side effects trong các functional components của React. Hướng dẫn toàn diện này sẽ giúp bạn hiểu rõ các Hooks được sử dụng phổ biến nhất, best practices, và giải pháp cho các vấn đề thường gặp.

### useState Hook

Hook cơ bản nhất để quản lý state trong functional components.

**Cách sử dụng cơ bản:**
```javascript
const [state, setState] = useState(initialValue);
```

**Best Practices:**

+ **Nhiều biến State:**

```javascript
const [age, setAge] = useState(25);
const [name, setName] = useState('John');
const [isOnline, setIsOnline] = useState(false);
```

+ **State dạng Object:**

```javascript
const [user, setUser] = useState({
  name: 'John',
  age: 25,
  isOnline: false
});
// Cập nhật object state
setUser(prev => ({
  ...prev,
  age: prev.age + 1
}));
```

+ **Lazy Initial State:**

```javascript
const [token] = useState(() => {
  return localStorage.getItem('token') || 'default-token';
});
```

### useEffect Hook

Để xử lý các side effects trong functional components.

**Các Pattern Phổ Biến:**

+ **Chạy sau mỗi lần Render:**

```javascript
useEffect(() => {
  // Chạy sau mỗi lần render
  document.title = `Count: ${count}`;
});
```

+ **Chỉ chạy một lần (Khi Mount):**

```javascript
useEffect(() => {
  // Chỉ chạy khi mount
  fetchData();
}, []);
```

+ **Chạy khi Dependencies cụ thể thay đổi:**

```javascript
useEffect(() => {
  // Chạy khi count thay đổi
  console.log('Count changed:', count);
}, [count]);
```

+ **Cleanup khi Unmount:**

```javascript
useEffect(() => {
  const subscription = api.subscribe();

  // Hàm cleanup
  return () => {
    subscription.unsubscribe();
  };
}, []);
```

### useContext Hook

Để sử dụng React context trong components.

**Ví dụ Setup:**

```javascript
// Tạo context
const ThemeContext = createContext('light');

// Provider component
const ThemeProvider = ({ children }) => {
  const [theme, setTheme] = useState('light');

  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};

// Consumer component
const ThemedButton = () => {
  const { theme, setTheme } = useContext(ThemeContext);
  return (
    <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}>
      Current theme: {theme}
    </button>
  );
};
```

### useReducer Hook

Để quản lý state phức tạp với actions và reducers.

**Cài đặt cơ bản:**
```javascript
const initialState = { count: 0 };

function reducer(state, action) {
  switch (action.type) {
    case 'increment':
      return { count: state.count + 1 };
    case 'decrement':
      return { count: state.count - 1 };
    default:
      throw new Error('Unknown action');
  }
}

function Counter() {
  const [state, dispatch] = useReducer(reducer, initialState);

  return (
    <>
      Count: {state.count}
      <button onClick={() => dispatch({ type: 'increment' })}>+</button>
      <button onClick={() => dispatch({ type: 'decrement' })}>-</button>
    </>
  );
}
```

### useCallback Hook

Để memoize các function nhằm tránh re-render không cần thiết.

**Ví dụ Best Practice:**
```javascript
const MemoizedComponent = React.memo(({ onSubmit }) => {
  return <button onClick={onSubmit}>Submit</button>;
});

const Parent = () => {
  const [count, setCount] = useState(0);

  const handleSubmit = useCallback(() => {
    console.log('Form submitted');
  }, []); // Mảng deps rỗng vì function không phụ thuộc vào giá trị nào

  return (
    <div>
      <button onClick={() => setCount(c => c + 1)}>Count: {count}</button>
      <MemoizedComponent onSubmit={handleSubmit} />
    </div>
  );
};
```

### useMemo Hook

Để memoize các giá trị được tính toán.

**Khi nào nên sử dụng:**
1. Các phép tính phức tạp tốn kém
2. Kiểm tra tham chiếu bằng nhau cho objects
3. Ngăn chặn re-render không cần thiết

```javascript
const ExpensiveComponent = ({ items, query }) => {
  const filteredItems = useMemo(() => {
    return items.filter(item =>
      item.name.toLowerCase().includes(query.toLowerCase())
    );
  }, [items, query]); // Chỉ tính toán lại khi items hoặc query thay đổi

  return (
    <ul>
      {filteredItems.map(item => (
        <li key={item.id}>{item.name}</li>
      ))}
    </ul>
  );
};
```

### useRef Hook

Để duy trì giá trị giữa các lần render và truy cập các phần tử DOM.

**Các trường hợp sử dụng phổ biến:**

+ **Tham chiếu DOM:**

```javascript
function TextInputWithFocus() {
  const inputRef = useRef();

  const focusInput = () => {
    inputRef.current.focus();
  };

  return (
    <>
      <input ref={inputRef} type="text" />
      <button onClick={focusInput}>Focus Input</button>
    </>
  );
}
```

+ **Lưu trữ giá trị trước đó:**

```javascript
function Counter() {
  const [count, setCount] = useState(0);
  const prevCountRef = useRef();

  useEffect(() => {
    prevCountRef.current = count;
  });

  return (
    <div>
      Hiện tại: {count}, Trước đó: {prevCountRef.current}
      <button onClick={() => setCount(c => c + 1)}>Increment</button>
    </div>
  );
}
```

### Các React Hooks Mới Nhất (React 18+)

React 18 đã giới thiệu một số hooks mới cung cấp thêm chức năng:

+ **useTransition:**

```javascript
function App() {
  const [isPending, startTransition] = useTransition();
  const [count, setCount] = useState(0);

  function handleClick() {
    startTransition(() => {
      setCount(c => c + 1);
    });
  }

  return (
    <div>
      {isPending && <Spinner />}
      <button onClick={handleClick}>{count}</button>
    </div>
  );
}
```

+ **useDeferredValue:**

```javascript
function SearchResults({ query }) {
  const deferredQuery = useDeferredValue(query);

  return (
    <ul>
      {/* Sử dụng deferredQuery cho các thao tác tìm kiếm phức tạp */}
      {getSearchResults(deferredQuery).map(item => (
        <li key={item.id}>{item.name}</li>
      ))}
    </ul>
  );
}
```

### Tóm Tắt Best Practices

1. **Mảng Dependencies:**
   - Luôn bao gồm tất cả các biến được sử dụng trong useEffect/useCallback/useMemo vào mảng dependencies
   - Sử dụng quy tắc exhaustive-deps của ESLint để phát hiện dependencies bị thiếu

2. **Cập nhật State:**
   - Sử dụng functional updates khi state mới phụ thuộc vào state trước đó
   - Giữ state tối thiểu và tính toán dữ liệu khi có thể

3. **Tối ưu hiệu suất:**
   - Đừng tối ưu hóa quá sớm
   - Sử dụng React DevTools Profiler để xác định các vấn đề về hiệu suất
   - Chỉ memoize khi cần thiết

4. **Custom Hooks:**
   - Tách logic có thể tái sử dụng thành custom hooks
   - Tuân theo quy ước đặt tên "use"
   - Giữ custom hooks tập trung vào một trách nhiệm duy nhất

### Các Lỗi Phổ Biến Cần Tránh

1. **useState:**
   - Không gọi Hooks bên trong vòng lặp hoặc điều kiện
   - Không thay đổi state trực tiếp
   - Sử dụng functional updates cho state phụ thuộc vào state trước đó

2. **useEffect:**
   - Không bỏ qua cleanup function
   - Không quên mảng dependencies
   - Không sử dụng objects hoặc arrays làm dependencies mà không có memoization phù hợp

3. **useCallback/useMemo:**
   - Không lạm dụng chúng
   - Không quên mảng dependencies
   - Không memoize mọi thứ theo mặc định

Hãy nhớ rằng Hooks là công cụ mạnh mẽ, nhưng chúng nên được sử dụng một cách khôn ngoan. Luôn cân nhắc xem Hook có cần thiết cho trường hợp sử dụng của bạn hay không, và đảm bảo tuân theo các quy tắc của React về Hooks để components hoạt động đúng cách.

Để biết thêm thông tin, tham khảo:
- [Tài liệu React Hooks](https://react.dev/reference/react)
- [Quy tắc của Hooks](https://react.dev/warnings/invalid-hook-call-warning)
- [React Hooks Cheatsheet](https://blog.logrocket.com/react-hooks-cheat-sheet-solutions-common-problems/)