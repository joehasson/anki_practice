import random


def sort(A) -> None:
    _quicksort(A, 0, len(A) - 1)


def _quicksort(A: list[int], lo: int, hi: int) -> None:
    if lo >= hi:
        return

    i = _partition(A,lo,hi)
    _quicksort(A,lo,i-1)
    _quicksort(A,i+1,hi)


def _partition(A: list[int], lo: int, hi: int) -> int:
    """
    Modify array A such that
        - A[lo:i] contains elements less than or equal to A[i]
        - A[i+1:hi+1] contains elements strictly greater than A[i]
    """
    pivot = A[hi] # randomise later
    i = lo
    j = lo

    # loop invariants, vacuously true on intialization:
    # - A[lo:i] contain elements less than pivot
    # - A[i:j] contains elements strictly greater than pivot
    while j < hi:
        if A[j] <= pivot:
            A[i], A[j] = A[j], A[i]
            i += 1
        j += 1

    # On termination, j = hi so:
    # - A[lo:i] contians elements less than pivot
    # - A[i:hi] contains elements greater than pivot
    # - A[hi] is the pivot

    # Swapping i and hi we obtain
    # - A[lo:i] contians elements less than pivot
    # - A[i+1:hi+1] contains elements greater than pivot
    # - A[i] is the pivot
    A[hi], A[i] = A[i], A[hi]

    return i

