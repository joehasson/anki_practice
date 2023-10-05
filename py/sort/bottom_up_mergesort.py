def sort(A: list[int]) -> list[int]:
    sorted = []
    for i, e in enumerate(A):
        sorted.append([e])
        mergepairs(sorted, i+1)

    while len(sorted) > 1:
        mergepairs(sorted, 0)
    return sorted[0] 
    
def merge(A: list[int], B: list[int]) -> list[int]:
    merged = []
    while A and B:
        least = A if A[0] <= B[0] else B
        merged.append(least.pop(0))

    merged.extend(A)
    merged.extend(B)

    return merged

def mergepairs(A: list[list[int]], i: int) -> None:
    if len(A) < 2:
        return
    if i % 2 == 1:
        return
    A[-2] = merge(A[-2], A[-1])
    del A[-1]
    mergepairs(A, i // 2)

if __name__ == "__main__":
    sort([5,4,2,1,3])


