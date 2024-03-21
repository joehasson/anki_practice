def sort(A: list[int]) -> None:
    # Invariant: A[:i] is sorted and all less than subsequent
    for i in range(len(A) - 1):
        index_of_least = i
        for j in range(i, len(A)):
            if A[j] < A[index_of_least]:
                index_of_least = j
        A[i], A[index_of_least] = A[index_of_least], A[i]

