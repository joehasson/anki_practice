from metaclass_with_properties import DefinesFoo
import pytest


def test_positive() -> None:
    class baz(metaclass=DefinesFoo):
        def foo(self):
            return True

def test_positive_inheritance() -> None:
    class baz(metaclass=DefinesFoo):
        def foo(self):
            return True

    class foo(baz): pass
    class bax(foo): pass
    class quux(baz): pass
    class boz(bax, dict): pass
    with pytest.raises(AssertionError):
        class Boz(quux): pass

def test_negative_namecase() -> None:
    with pytest.raises(AssertionError):
        class Baz(metaclass=DefinesFoo):
            def foo(self):
                return True

def test_negative_attr() -> None:
    with pytest.raises(AssertionError):
        class baz(metaclass=DefinesFoo):
            pass

