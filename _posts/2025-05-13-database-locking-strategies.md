---
layout: post
title: "Understanding Database Locking Strategies: Pessimistic vs Optimistic"
subtitle: "Choosing the right approach for data consistency"
cover-img: /assets/img/docker-bg.png
thumbnail-img: /assets/img/docker-bg.png
share-img: /assets/img/docker-bg.png
tags: [database, consistency, concurrency]
author: kieetnvt
---

In modern multi-user applications, managing concurrent access to data is crucial for maintaining data consistency and integrity. Two primary strategies emerge when dealing with concurrent data access: Pessimistic Locking and Optimistic Locking. Let's explore both approaches and understand when to use each one.

## Pessimistic Locking

Pessimistic locking takes a "better safe than sorry" approach, assuming that conflicts are likely to occur. It's like putting a "Do Not Disturb" sign on your hotel room door before you even see anyone in the hallway.

### How It Works

1. When a user wants to modify data:
   - The system first acquires an exclusive lock on the data
   - Other users are blocked from accessing or modifying the locked data
   - The operation is performed
   - The lock is released

```sql
-- Example of pessimistic locking in PostgreSQL
BEGIN;
SELECT * FROM accounts
WHERE id = 123
FOR UPDATE;  -- This locks the row
-- Make updates here
COMMIT;     -- This releases the lock
```

![pessimistic-locking](/assets/img/pessimistic-locking.png)

### Advantages
- Guarantees data integrity by preventing conflicts
- Ideal for critical operations (financial transactions)
- Ensures consistent data state throughout the transaction

### Disadvantages
- Reduces system concurrency
- Can lead to deadlocks
- May impact performance under high contention

### Best Used For
- Financial transactions
- Inventory management
- Systems with high data contention
- Critical operations requiring absolute consistency

## Optimistic Locking

Optimistic locking takes a more relaxed approach, assuming conflicts are rare. It's like making changes to a shared document assuming no one else is editing it at the same time.

### How It Works

1. Read the data and its version number
2. Make modifications without locking
3. Before saving:
   - Check if the version hasn't changed
   - If unchanged: commit the changes
   - If changed: abort and retry

```sql
-- Example of optimistic locking in PostgreSQL
BEGIN;
UPDATE accounts
SET balance = new_balance,
    version = version + 1
WHERE id = 123
AND version = current_version;
COMMIT;
```

![optimistic-locking](/assets/img/optimistic-locking.png)

### Advantages
- Higher concurrency and throughput
- No blocking or deadlocks
- Perfect for read-heavy applications
- Works well in distributed systems

### Disadvantages
- Requires retry logic
- Potential wasted computation if conflicts occur
- Not suitable for high-conflict scenarios

### Best Used For
- Content management systems
- Social media feeds
- Reporting dashboards
- Systems with rare write conflicts

## Best Practices

1. **Minimize Lock Duration**
   - Hold locks for the shortest possible time
   - Prepare data before acquiring locks
   - Release locks as soon as possible

2. **Use Fine-Grained Locking**
   - Prefer row-level locks over table locks
   - Lock only the necessary data
   - Avoid locking related data unnecessarily

3. **Implement Proper Error Handling**
   - Have robust retry mechanisms for optimistic locking
   - Set appropriate timeouts for pessimistic locks
   - Handle deadlock scenarios gracefully

4. **Monitor Lock Behavior**
   - Track lock wait times
   - Monitor deadlock occurrences
   - Analyze lock contention patterns

## Making the Choice

Choose your locking strategy based on:

1. **Data Access Patterns**
   - High conflict rate → Pessimistic
   - Low conflict rate → Optimistic

2. **Application Requirements**
   - Critical consistency → Pessimistic
   - High throughput → Optimistic

3. **System Architecture**
   - Distributed system → Optimistic
   - Monolithic system → Either approach works

4. **Business Impact**
   - High cost of conflicts → Pessimistic
   - High cost of waiting → Optimistic

## Conclusion

Both locking strategies have their place in modern applications. The key is understanding your specific use case and requirements. Consider factors like data access patterns, consistency requirements, and system architecture when making your choice. Remember that you can also use both strategies in different parts of your application based on specific needs.

For critical operations like financial transactions, pessimistic locking provides the safety you need. For general-purpose operations where conflicts are rare, optimistic locking offers better performance and scalability. Choose wisely, and your application will maintain both data integrity and performance.