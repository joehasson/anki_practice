import itertools
import random
import pytest
from enum import Enum

import avl_sort
import bottom_up_mergesort
import heap_sort
import heap_sort_builtins
import insertion_sort
import quicksort
import selection_sort
import top_down_mergesort

class SortType(Enum):
    IN_PLACE = 0
    PURE = 1

params = (
    pytest.param(avl_sort.sort, SortType.PURE, id="AVL sort"),
    pytest.param(bottom_up_mergesort.sort, SortType.PURE, id="Bottom up mergesort"),
    pytest.param(heap_sort.sort, SortType.IN_PLACE, id="Heap sort"),
    pytest.param(heap_sort_builtins.sort, SortType.PURE, id="Heap sort builtins"),
    pytest.param(insertion_sort.sort, SortType.IN_PLACE, id="Insertion sort"),
    pytest.param(quicksort.sort, SortType.IN_PLACE, id="Quicksort"),
    pytest.param(selection_sort.sort, SortType.IN_PLACE, id="Selection sort"),
    pytest.param(top_down_mergesort.sort, SortType.PURE, id="Top down mergesort"),
)

@pytest.mark.parametrize(
        ('sort', 'typ'),
        params
)
@pytest.mark.parametrize(
        ('input', 'expected'),
        (
            pytest.param([], [], id="empty"),
            pytest.param([1], [1], id="singleton"),
            pytest.param([5,4,1,3], [1,3,4,5], id="Four elements"),
            pytest.param([2,3,4,1,5], [1,2,3,4,5], id="Five elements")
        )
)
def test_sort(sort, typ, input, expected) -> None:
    if typ == SortType.IN_PLACE:
        sort(input)
        assert input == expected
    elif typ == SortType.PURE:
        assert sort(input) == expected


@pytest.mark.parametrize(
        ('sort', 'typ'),
        params
)
def test_sort_randoms(sort, typ) -> None:
    for _ in range(10):
        size = random.randint(1, 1000)
        random_lst = [random.randint(1, 100000) for _ in range(size)]
        if typ == SortType.PURE:
            assert is_sorted(sort(random_lst))
        elif typ == SortType.IN_PLACE:
            sort(random_lst)
            assert is_sorted(random_lst)


def is_sorted(lst: list) -> bool:
    return all(a <= b for a, b in itertools.pairwise(lst))
