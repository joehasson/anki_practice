from __future__ import annotations

from typing import Generator

def sort(A: list[int]) -> list[int]:
    t = AVLTree()
    for e in A:
        t.insert(e)
    return list(t)

class AVLTree:
    def __init__(self, root: AVLNode | None = None):
        self.root = root

    def insert(self, x: int) -> None:
        if self.root is not None:
            self.root.insert(x)
        else:
            self.root = AVLNode(x,1,None,None)

    def __iter__(self) -> Generator[int,None,None]:
        if self.root:
            yield from self.root
        
class AVLNode:
    def __init__(self, x: int, height: int, left: AVLNode | None, right: AVLNode | None):
        self.val = x
        self.height = height
        self.left = left
        self.right = right

    def __iter__(self) -> Generator[int, None, None]:
        if self.left is not None:
            yield from self.left
        yield self.val
        if self.right is not None:
            yield from self.right

    def insert(self, x: int) -> None:
        if x < self.val:
            if self.left:
                self.left.insert(x)
            else:
                self.left = AVLNode(x,1,None,None)
        else:
            if self.right:
                self.right.insert(x)
            else:
                self.right = AVLNode(x,1,None,None)

        self.rebalance()
        self.validate_invariants()

    def rebalance(self) -> None:
        if self.skew == 2:
            assert self.right is not None
            if self.right.skew == 1:
                self.rotate_left()

        elif self.skew == -2

    def rotate_right(self) -> None:
        ...

    def rotate_left(self) -> None:
        ...

    @property
    def skew(self) -> int:
        rh = self.right.height if self.right else 0
        lh = self.left.height if self.left else 0
        return rh - lh

    def validate_invariants(self: AVLNode) -> None:
        # BST
        if self.left:
            assert self.val > self.left.val
        if self.right:
            assert self.val <= self.right.val
        
        def calc_real_height(node):
            return 0 if node is None else 1 + max(height(node.left), height(node.right))

        # We maintain height
        assert self.height == calc_real_height(node)

        # Tree is height balanced
        assert self.skew in (-1, 0, 1)

        if self.left: self.left.validate_invariants()
        if self.right: self.right.validate_invariants()


