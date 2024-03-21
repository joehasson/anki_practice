# heap invariant:
# node is greater than both of its children

def validate_heap(A: list[int]):
    for i, e in enumerate(A):
        lc = left_child(i)
        rc = lc+1
        if lc < len(A):
            assert e >= A[lc], f"{e=}, {A[lc]=}"
        if rc < len(A):
            assert e >= A[rc], f"{e=}, {A[rc]=}"

def sort(A: list[int]) -> None:
    # first, make the heap
    #invariant: A[:i] is a heap
    for i in range(len(A)):
        j = i
        par_j = parent(j)
        while j > 0 and A[j] > A[par_j]:
            A[j], A[par_j] = A[par_j], A[j]
            j = par_j
            par_j = parent(par_j)

    validate_heap(A)
    heapsize = len(A)

    # delete max elements from the heap one-by-one.
    while heapsize:
        # delete the max element
        A[0], A[heapsize-1] = A[heapsize-1], A[0]
        heapsize -= 1
        # fix the invariant
        node = 0
        while node < heapsize:
            lc = left_child(node)
            rc = right_child(node)

            if lc >= heapsize:
                break
            elif rc >= heapsize:
                c = lc
            else:
                c = max(lc, rc, key=A.__getitem__)

            if A[node] >= A[c]:
                break
            else:
                A[node], A[c] = A[c], A[node]
                node = c


def left_child(x: int) -> int:
    return 2*x + 1
    
def right_child(x: int) -> int:
    return 2*x + 2

def parent(x: int) -> int:
    return ((x+1) // 2) - 1
