def sort(A: list[int]) -> None:
    #invariant: A[:i] is the original eles in
    # sorted order
    for i in range(1, len(A)):
        j = i
        while j > 0 and A[j] < A[j-1]:
            A[j], A[j-1] = A[j-1], A[j]
            j -= 1
