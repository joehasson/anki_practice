def sort(A: list[int]) -> None:
    # Loop invariant: A[:i] is sorted
    # Loop invariant x in A[:i] < y in A[i:]
    for i in range(len(A) - 1):
        least = i
        for j in range(i+1, len(A)):
            if A[j] < A[least]:
                least = j
        A[i], A[least] = A[least], A[i]

