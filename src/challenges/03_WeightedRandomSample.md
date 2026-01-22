# Weighted Random Sampling Interview Challenge

This problem is split into multiple stages to discuss data structures and complexity.

## Stage 1a: The Naive Array

**Prompt:**
"Imagine we are building a lottery. Users deposit tokens (stake), and we need to pick a winner. The more tokens you have, the higher your chance of winning. How would you store this and pick a winner?"

**Discussion:**
- Propose a data structure.
- Analyze the time complexity for:
  - Insert
  - Update
  - Removal
  - Draw (Picking a winner)

**Problem:**
How can we improve the draw time complexity?

## Stage 1b: The Naive Ticketing

**Prompt:**
"What if we added an entry for every single token unit? For example, if Alice has 20 tokens, we add 20 entries. If Bob has 30, add 30 entries."

**Discussion:**
- Analyze the complexity for Insert, Removal, and Update.
- Why is this approach generally not tenable for a smart contract?

**transition:**
Can we combine these entries into a bucket? Think about "buckets of buckets" (Sum Tree).

## Stage 2: The "Prefix Sum" Array

**Prompt:**
"How can we make the drawing process faster? What if we pre-calculate the cumulative sums?"

**Discussion:**
- Propose a data structure where `sums[i] = stake[0] + ... + stake[i]`.
- Analyze the time complexity for:
  - Insert
  - Removal
  - Draw (Binary Search)
  - Update

**Problem:**
Updating one person's stake at the beginning of the array forces us to update every subsequent element in the prefix sum array. Update becomes O(n). How can we prevent ourselves from updating every subsequent element?

## Stage 3: The Sum Tree

**Prompt:**
"We need both the Draw and the Update to be fast. We've seen that arrays make one fast and the other slow. Is there a data structure that handles both logarithmic updates and logarithmic searches?"

**Discussion:**
- Design a tree structure where internal nodes store the sum of their children.
- Analyze the time complexity for:
  - Insert
  - Update
  - Removal
  - Draw

## Stage 4: Implementation & Optimization

**Prompt:**
1. **The Array Representation:**
   - Can we represent a K-ary tree using a flat array (where index `i` has children at `K*i + 1` ... `K*i + K`)?

2. **Managing Vacancy:**
   - How do we handle users leaving the tree without leaving "dead" empty leaves that make the tree unnecessarily deep?

3. **The Branching Factor (K):**
   - Discuss the trade-off of the `K` parameter.
   - What happens with a higher `K`? (Tree depth vs. Draw cost per node)
