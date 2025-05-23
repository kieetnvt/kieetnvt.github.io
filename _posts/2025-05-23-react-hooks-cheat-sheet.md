---
layout: post
title: "React Hooks Cheat Sheet: Best Practices and Common Solutions"
subtitle: "A comprehensive guide to React Hooks with practical examples"
cover-img: /assets/img/react-hooks-cheat-sheet-solutions-common-problems.png
thumbnail-img: /assets/img/react-hooks-cheat-sheet-solutions-common-problems.png
share-img: /assets/img/react-hooks-cheat-sheet-solutions-common-problems.png
tags: [react, hooks, javascript, frontend]
author: kieetnvt
---

React Hooks revolutionized state management and side effects in React's functional components. This comprehensive guide will walk you through the most commonly used Hooks, best practices, and solutions to common problems.

### useState Hook

The most basic Hook for managing state in functional components.

**Basic Usage:**
```javascript
const [state, setState] = useState(initialValue);
```

**Best Practices:**

+ **Multiple State Variables:**

```javascript
const [age, setAge] = useState(25);
const [name, setName] = useState('John');
const [isOnline, setIsOnline] = useState(false);
```

+ **Object State:**

```javascript
const [user, setUser] = useState({
  name: 'John',
  age: 25,
  isOnline: false
});
// Update object state
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

For handling side effects in functional components.

**Common Patterns:**

+ **Run on Every Render:**

```javascript
useEffect(() => {
  // This runs after every render
  document.title = `Count: ${count}`;
});
```

+ **Run Only Once (On Mount):**

```javascript
useEffect(() => {
  // This runs only on mount
  fetchData();
}, []);
```

+ **Run on Specific Dependencies:**

```javascript
useEffect(() => {
  // This runs when count changes
  console.log('Count changed:', count);
}, [count]);
```

+ **Cleanup on Unmount:**

```javascript
useEffect(() => {
  const subscription = api.subscribe();

  // Cleanup function
  return () => {
    subscription.unsubscribe();
  };
}, []);
```

### useContext Hook

For consuming React context in components.

**Example Setup:**

```javascript
// Create context
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

For complex state management with actions and reducers.

**Basic Implementation:**
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

For memoizing functions to prevent unnecessary re-renders.

**Best Practice Example:**
```javascript
const MemoizedComponent = React.memo(({ onSubmit }) => {
  return <button onClick={onSubmit}>Submit</button>;
});

const Parent = () => {
  const [count, setCount] = useState(0);

  const handleSubmit = useCallback(() => {
    console.log('Form submitted');
  }, []); // Empty deps array since function doesn't depend on any values

  return (
    <div>
      <button onClick={() => setCount(c => c + 1)}>Count: {count}</button>
      <MemoizedComponent onSubmit={handleSubmit} />
    </div>
  );
};
```

### useMemo Hook

For memoizing computed values.

**When to Use:**
1. Expensive calculations
2. Reference equality for objects
3. Preventing unnecessary re-renders

```javascript
const ExpensiveComponent = ({ items, query }) => {
  const filteredItems = useMemo(() => {
    return items.filter(item =>
      item.name.toLowerCase().includes(query.toLowerCase())
    );
  }, [items, query]); // Only recompute when items or query changes

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

For persisting values between renders and accessing DOM elements.

**Common Use Cases:**

+ **DOM References:**

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

+ **Previous Value Storage:**

```javascript
function Counter() {
  const [count, setCount] = useState(0);
  const prevCountRef = useRef();

  useEffect(() => {
    prevCountRef.current = count;
  });

  return (
    <div>
      Current: {count}, Previous: {prevCountRef.current}
      <button onClick={() => setCount(c => c + 1)}>Increment</button>
    </div>
  );
}
```

### Latest React Hooks (React 18+)

React 18 introduced several new hooks that provide additional functionality:

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
      {/* Use deferredQuery for expensive search operation */}
      {getSearchResults(deferredQuery).map(item => (
        <li key={item.id}>{item.name}</li>
      ))}
    </ul>
  );
}
```

### Best Practices Summary

1. **Dependencies Array:**
   - Always include all variables used inside useEffect/useCallback/useMemo in their dependencies array
   - Use ESLint's exhaustive-deps rule to catch missing dependencies

2. **State Updates:**
   - Use functional updates when new state depends on previous state
   - Keep state minimal and derive data when possible

3. **Performance Optimization:**
   - Don't optimize prematurely
   - Use React DevTools Profiler to identify performance issues
   - Memoize only when necessary

4. **Custom Hooks:**
   - Extract reusable logic into custom hooks
   - Follow the "use" naming convention
   - Keep custom hooks focused on a single responsibility

### Common Pitfalls to Avoid

1. **useState:**
   - Don't call Hooks inside loops or conditions
   - Don't mutate state directly
   - Use functional updates for state that depends on previous state

2. **useEffect:**
   - Don't ignore the cleanup function
   - Don't forget dependencies array
   - Don't use objects or arrays as dependencies without proper memoization

3. **useCallback/useMemo:**
   - Don't overuse them
   - Don't forget dependencies array
   - Don't memoize everything by default

Remember that Hooks are powerful tools, but they should be used judiciously. Always consider whether a Hook is necessary for your use case, and make sure to follow React's rules of Hooks to ensure your components behave correctly.

For more information, refer to:
- [React Hooks Documentation](https://react.dev/reference/react)
- [Rules of Hooks](https://react.dev/warnings/invalid-hook-call-warning)
- [React Hooks Cheatsheet](https://blog.logrocket.com/react-hooks-cheat-sheet-solutions-common-problems/)