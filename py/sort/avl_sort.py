from __future__ import annotations
from typing import Generator

def sort(A: list[int]) -> list[int]:
    t = AVLTree()
    for e in A:
        t.insert(e)
    return [e for e in t]

# AVL Tree 
# we maintain that the ~skew~ of a given node is in [-1, 1], where
# skew is defined to be height(node.right) - height(node.left)
# We call this property height balanced.
#
# This entails that the tree is balanced, i.e. that h = O(log n).

class AVLTree:
    def __init__(self):
        self.root: AVLNode | None = None

    def insert(self, x: int) -> None:
        if self.root is not None:
            self.root.insert(x)
        else:
            self.root = AVLNode(x)
        #self.root._validate()

    def __iter__(self) -> Generator[int, None, None]:
        if self.root:
            yield from self.root

class AVLNode:
    def __init__(self, label: int, height=1, left: None | AVLNode = None, right: None | AVLNode = None):
        self.label = label
        self.height = height
        self.left = left
        self.right = right

    def _validate(self):
        if self.left:
            self.left._validate()
        if self.right:
            self.right._validate()

        def realheight(node):
            return 1 + max(realheight(node.left), realheight(node.right)) if node else 0
        assert self.height == realheight(self)
        assert self.skew in (-1, 0, 1)

    def insert(self, x: int) -> None:
        if x <= self.label:
            if self.left:
                self.left.insert(x)
            else:
                self.left = AVLNode(x)
            lh = self.left.height if self.left else 0
            rh = self.right.height if self.right else 0
            self.height = max(lh,rh) + 1

        elif x > self.label:
            if self.right:
                self.right.insert(x)
            else:
                self.right = AVLNode(x)
            lh = self.left.height if self.left else 0
            rh = self.right.height if self.right else 0
            self.height = max(lh,rh) + 1

        if self.skew == 2:
            assert self.right
            if self.right.skew == -1:
                self.right.rotate_right()
            self.rotate_left()
            
        if self.skew == -2:
            assert self.left
            if self.left.skew == 1:
                self.left.rotate_left()
            self.rotate_right()


    def rotate_left(self):
        # Take a tree
        #           x
        #         /   \
        #        A      y
        #             /   \
        #            B      C
        assert self.right is not None

        # save ptrs
        A = self.left
        B = self.right.left
        C = self.right.right

        # swap x and y labels to produce
        #           y
        #         /   \
        #        A      x
        #             /   \
        #            B      C
        self.label, self.right.label = self.right.label, self.label

        # Produce
        #         y
        #       /   \
        #      x      x
        #     / \    / \
        #    B   C  B   C
        self.left = self.right

        # now have
        #        y
        #      /   \
        #     x      C
        #    / \
        #   A   B
        self.left.left = A
        self.left.right = B
        self.right = C

        # Restore heights
        h = lambda t: t.height if t else 0
        self.left.height = max(h(A), h(B)) + 1
        self.height = max(self.left.height, h(C)) + 1

    def rotate_right(self):
        # take a tree
        #        x
        #      /   \
        #     y      C
        #    / \
        #   A   B
        assert self.left
        
        # save ptrs
        A = self.left.left
        B = self.left.right
        C = self.right

        # swap x and y to get
        #        y
        #      /   \
        #     x      C
        #    / \
        #   A   B
        self.label, self.left.label = self.left.label, self.label

        # obtain
        #        y
        #      /   \
        #     x      x
        #    / \    / \
        #   A   B  A   B
        self.right = self.left

        # now have
        #           y
        #         /   \
        #        A      x
        #             /   \
        #            B      C
        self.left = A
        self.right.left = B
        self.right.right = C

        # fix heights
        h = lambda t: t.height if t else 0
        self.right.height = max(h(B), h(C)) + 1
        self.height = max(self.right.height, h(A)) + 1

    @property
    def skew(self) -> int:
        lh = self.left.height if self.left else 0
        rh = self.right.height if self.right else 0
        return rh - lh

    def __iter__(self) -> Generator[int, None, None]:
        if self.left:
            yield from self.left
        yield self.label
        if self.right:
            yield from self.right

