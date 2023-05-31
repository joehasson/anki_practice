from typing import Type
from typing_extensions import Self

class DefinesFoo(type):
    def __new__(cls: Type[Self], name: str, bases: tuple[type], body: dict):
        assert name == name.lower()
        assert ("foo" in body) or any(any(hasattr(k, "foo") for k in base.__mro__) for base in bases)
        return super().__new__(cls, name, bases, body)


class baz(metaclass=DefinesFoo):
    def foo(self):
        return True

class bax(baz):
    pass

