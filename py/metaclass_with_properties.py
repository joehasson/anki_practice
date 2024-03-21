class DefinesFoo(type):
    def __new__(cls, name, bases, body):
        assert name == name.lower()
        assert DefinesFoo.defines_foo(body, bases)
        return super().__new__(cls, name, bases, body)
        
    @staticmethod
    def defines_foo(body, bases):
        return "foo" in body or any(DefinesFoo.defines_foo(base.__dict__, base.__bases__) for base in bases)
