---
name: 'Testing Standards'
description: 'Guidelines for writing tests'
applyTo: '**/*.test.{ts,tsx}'
---

# Testing Guidelines

## Test Structure
- Use `describe` for grouping related tests
- Use `it` or `test` for individual test cases
- Follow AAA pattern: Arrange, Act, Assert

## React Testing
- Prefer `screen.getByRole` over other queries
- Test user behavior, not implementation
- Mock external dependencies
- Use `userEvent` over `fireEvent`

## Example
```typescript
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { LoginForm } from './LoginForm';

describe('LoginForm', () => {
  it('should submit form with valid credentials', async () => {
    // Arrange
    const handleSubmit = vi.fn();
    render(<LoginForm onSubmit={handleSubmit} />);

    // Act
    await userEvent.type(screen.getByLabelText(/email/i), 'test@example.com');
    await userEvent.type(screen.getByLabelText(/password/i), 'password123');
    await userEvent.click(screen.getByRole('button', { name: /login/i }));

    // Assert
    expect(handleSubmit).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password123'
    });
  });
});
```
