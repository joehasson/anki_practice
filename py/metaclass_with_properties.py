class BaseMeta(type):
    def __new__(cls, name: str, bases, body):
        assert name == name.lower()
        assert "foo" in body or any("foo" in base.__dict__ for base in bases)
        return super().__new__(cls, name, bases, body)


class base(metaclass=BaseMeta):
    def foo(self):
        return self.bar()


class derived(base):
    def bar(self):
        return 4

base()
derived()

# Metaclasses are classes which inherit from type and allow 
# you to intercept the creation of new types.

