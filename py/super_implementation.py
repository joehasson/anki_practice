import inspect

class MySuper:
    def __init__(self):
        local_vars = inspect.currentframe().f_back.f_locals
        self.__self__, *_ = local_vars.values()
        self.__self_class__ = type(self.__self__)
        self.__thisclass__ = local_vars['__class__']

    def __getattr__(self, a):
        mro = self.__self_class__.__mro__
        i = mro.index(self.__thisclass__) + 1

        while i < len(mro):
            if hasattr(mro[i], a):
                if hasattr(val := getattr(mro[i], a), '__get__'):
                    return val.__get__(self.__self__, self.__self_class__)
                return val
            i += 1

        raise AttributeError()

