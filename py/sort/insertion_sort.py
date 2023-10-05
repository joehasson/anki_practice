def sort(A: list[int]) -> None:
    # Invariant: A[:i] is the original
    # i but in sorted order
    for i in range(1, len(A)):
        while i > 0 and A[i] < A[i-1]:
            A[i], A[i-1] = A[i-1], A[i]
            i = i - 1

