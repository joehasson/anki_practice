#     0
#  8    4
# 6 5  2 9

def sort(A: list[int]) -> None:
    # --- Building the heap ---

    #[1,2]
    # Invariant: A[:i] is a max-heap, i.e. node >= children
    # Termination: A is a max-heap
    for i in range(1,len(A)):
        p = parent_of(i)
        while i > 0 and A[i] > A[p]:
            A[i], A[p] = A[p], A[i]
            i = p
            p = parent_of(p)

    print(A)

    for i in range(len(A)):
        if left_child_of(i) < len(A):
            assert A[i] >= A[left_child_of(i)]
        if right_child_of(i) < len(A):
            assert A[i] >= A[right_child_of(i)]

    # --- Deleting from the heap; forming the result ---
    heapsize = len(A)
    # Invariants:
    #  (1) A[:heapsize] is a valid max-heap
    #  (2) heapsize = len(A) or A[heapsize:] is sorted ascending
    # Termination:
    #  A[0:] is sorted ascending
    while heapsize > 0:
        # Swap the max element out of the heap and decrease the 
        # heapsize to maintain (2)
        A[0], A[heapsize-1] = A[heapsize-1], A[0]
        heapsize -= 1
        # Restore the heap invariant after the swap
        p = 0
        while p < heapsize:
            lc = left_child_of(p)
            rc = right_child_of(p)
            # Find the larger of the two children, if any
            if lc >= heapsize:
                break
            elif rc >= heapsize:
                maxc = lc
            else:
                maxc = max(lc, rc, key=A.__getitem__)

            # Swap with child if larger than p and recurse
            if A[maxc] > A[p]:
                A[p], A[maxc] = A[maxc], A[p]
                p = maxc
            else:
                break


def parent_of(i: int) -> int:
    return ((i + 1) // 2) - 1

def left_child_of(i: int) -> int:
    return 2*i + 1

def right_child_of(i: int) -> int:
    return 2*i + 2

