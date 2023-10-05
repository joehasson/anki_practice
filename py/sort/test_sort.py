import pytest
from enum import Enum

import bottom_up_mergesort
import insertion_sort
import quicksort
import selection_sort

class SortType(Enum):
    IN_PLACE = 0
    PURE = 1

@pytest.mark.parametrize(
        ('sort', 'typ'),
        (
            pytest.param(bottom_up_mergesort.sort, SortType.PURE, id="Bottom up mergesort"),
            pytest.param(insertion_sort.sort, SortType.IN_PLACE, id="Insertion sort"),
            pytest.param(quicksort.sort, SortType.IN_PLACE, id="Quicksort"),
            pytest.param(selection_sort.sort, SortType.IN_PLACE, id="Selection sort"),
        )
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
