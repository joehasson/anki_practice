import pytest

from super_implementation import MySuper as super

class Root:
    def f(self):
        __class__
        print("Root.f")

class A(Root):
    def f(self):
        __class__
        print("A.f")
        super().f()

class B(Root):
    def f(self):
        __class__
        print("B.f")
        super().f()

class C(A, B):
    def f(self):
        __class__
        print("C.f")
        super().f()

class D(B, A):
    def f(self):
        __class__
        print("D.f")
        super().f()

c = C()
d = D()

def test_my_super(capsys) -> None:
    c = C()
    c.f()

    captured = capsys.readouterr()
    assert captured.out == "C.f\nA.f\nB.f\nRoot.f\n"

def test_my_super2(capsys) -> None:
    d = D()
    d.f()

    captured = capsys.readouterr()
    assert captured.out == "D.f\nB.f\nA.f\nRoot.f\n"

