def sort(A: list[int]) -> None:
    i = 1


def merge(A: list[int], lo1: int, lo2: int, end: int) -> None:
    """
    Pre-conditions:
        - A[lo1..lo2) is sorted
        - A[lo2..end) is sorted
    Post-condition:
        - A[lo1..end) is sorted
    """
    #loop invariant: A[i:end) is sorted
    ...

