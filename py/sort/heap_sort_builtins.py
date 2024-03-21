import heapq

def sort(A: list[int]) -> list[int]:
    h = []
    for e in A:
        heapq.heappush(h, e)
    return [heapq.heappop(h) for _ in range(len(A))]



