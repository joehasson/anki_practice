from typing import List

def quicksort(arr: List[int]) -> None:
    def sort(start: int, end: int) -> None:
        print('sorting', arr[start:end])
        pivot = arr[(start+end) // 2]
        left_pointer, right_pointer = start, end

        while left_pointer < right_pointer:
            while arr[left_pointer] < pivot:
                left_pointer += 1
            while arr[right_pointer] > pivot:
                right_pointer -= 1
            if left_pointer < right_pointer:
                arr[left_pointer], arr[right_pointer] = arr[right_pointer], arr[left_pointer]

        if start < right_pointer:
            sort(start, right_pointer)
        if left_pointer + 1 < end:
            sort(left_pointer, end)

    sort(0, len(arr)-1)

