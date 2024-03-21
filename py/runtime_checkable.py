import pytest
from typing import Protocol


def my_runtime_checkable(decorated_cls):
    class Wrapper(decorated_cls, Protocol):
        @classmethod
        def __subclasshook__(cls, subclass):
            return all(method in subclass.__dict__ for method in cls.__dict__)

    return Wrapper


class Foo(Protocol):
    def bar(self): ...

    def baz(self): ...

def test_positive() -> None:
    class Bar:
        def bar(self):
            return 100

        def baz(self):
            return 200

    assert issubclass(Bar, Foo), "False negative"


def test_negative() -> None:
    class Bar:
        pass
    assert not issubclass(Bar, Foo), "False positive"

