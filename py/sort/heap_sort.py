def sort(A: list[int]) -> None:
    heapsize = len(A)
    # Make our list a heap
    # Invariant: A[:i] is a valid heap
    for i in range(1, len(A)):
        print(f"Fixing {A[:i+1]}")
        max_heapify_up(A,i)
        print(f"Inserted element. New heap {A[:i+1]}")

    print(f"Created heap {A}")
    validate_heap(A,heapsize-1,0)
    print("Initial heap valid")

    while heapsize:
        _swap(A,0,heapsize-1) # Move max element to the end
        heapsize -= 1
        max_heapify_down(A,heapsize-1,0) # end element has been "deleted"; rebalance
        validate_heap(A,heapsize-1,0)

def max_heapify_up(A: list[int], i: int) -> None:
    if i == 0:
        return

    parent_i = parent_of(i)
    print(f"Comparing A[{i}] and A[{parent_i}]")
    if A[i] > A[parent_i]:
        _swap(A,i,parent_i)
        max_heapify_up(A,parent_i)

def max_heapify_down(A: list[int], end: int, i: int) -> None:
    """
    A: our array heap
    end: index of last heap element in A
    i: index from which to start heapifying down 
    """
    left_child_i = left_child(i)
    
    if left_child_i > end: # No children base case
        return

    right_child_i = right_child(i)
    if right_child_i > end:
        child_i = left_child_i
    else:
        child_i = max(left_child_i, right_child_i, key=A.__getitem__)

    if A[child_i] > A[i]:
        _swap(A,i,child_i)
        max_heapify_down(A, end, child_i)


def _swap(A: list[int], i: int, j: int) -> None:
    A[i], A[j] = A[j], A[i]

def left_child(i: int) -> int:
    return i * 2 + 1

def right_child(i: int) -> int:
    return i * 2 + 2

def parent_of(i: int) -> int:
    i += 1
    return (i // 2) - 1


def validate_heap(A: list[int], end: int, i: int) -> None:
    """
    For debugging
    """
    left_child_i = left_child(i)
    if left_child_i <= end:
        assert A[i] >= A[left_child_i]
        validate_heap(A,end,left_child_i)
    right_child_i = right_child(i)
    if right_child_i <= end:
        assert left_child_i # completeness
        assert A[i] >= A[right_child_i]
        validate_heap(A,end,right_child_i)


