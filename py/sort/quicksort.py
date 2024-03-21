def sort(A: list[int]) -> None:
    quicksort(A, 0, len(A) - 1)

def quicksort(A: list[int], p: int, r: int) -> None:
    if p >= r:
        return

    i = partition(A, p, r)
    quicksort(A,p,i-1)
    quicksort(A,i+1,r)

def partition(A: list[int], p: int, r: int) -> int:
    """
    Split a list into the elements less than
    the pivot and elements greater than the pivot.
    return the index of the pivot.
    """
    pivot = A[r]

    j = p 
    # Maintain loop invariants
    # A[p:j] <= pivot
    # A[j:i] > pivot
    # A[r] = pivot
    for i in range(p,r):
        if A[i] <= pivot:
            A[j], A[i] = A[i], A[j]
            j += 1

    # On termination we have
    # A[p:j] <= pivot
    # A[j:r] > pivot
    # A[r] = pivot

    # Establish that
    # A[p:j] <= pivot
    # A[j+1:r+1] > pivot
    # A[j] = pivot
    A[j], A[r] = A[r], A[j]
    return j

