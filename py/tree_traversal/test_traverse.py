import random

import pytest

import inorder
import preorder
import postorder

from bintree import Tree

def ref_inorder(T: Tree | None) -> list[int]:
    if T is None:
        return []
    return ref_inorder(T.left) + [T.label] + ref_inorder(T.right)

def ref_preorder(T: Tree | None) -> list[int]:
    if T is None:
        return []
    return [T.label] + ref_preorder(T.left) + ref_preorder(T.right)

def ref_postorder(T: Tree | None) -> list[int]:
    if T is None:
        return []
    return ref_postorder(T.left) + ref_postorder(T.right) + [T.label]

def random_tree(maxdepth: int) -> Tree | None:
    if maxdepth == 0 or not random.randint(0,1):
        return None

    return Tree(
            label=random.randint(1,100),
            left=random_tree(maxdepth-1),
            right=random_tree(maxdepth-1)
    )

@pytest.mark.parametrize(
        ('f', 'ref_f'),
        (
            (pytest.param(inorder.traverse, ref_inorder, id="ref inorder")),
            (pytest.param(preorder.traverse, ref_preorder, id="ref preorder")),
            (pytest.param(postorder.traverse, ref_postorder, id="ref postorder")),
        )
)
def test_traversal(f, ref_f):
    for _ in range(100):
        t = random_tree(random.randint(1,20))
        assert f(t) == ref_f(t)

