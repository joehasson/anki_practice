import inspect

class MySuper:
    def __init__(self):
        caller_frame = inspect.currentframe().f_back.f_locals #type: ignore
        self.obj = caller_frame["self"]
        self.thisclass = caller_frame["__class__"]
        self.objclass = type(self.obj)

    def __getattr__(self, attr):
        mro = self.objclass.__mro__
        i = mro.index(self.thisclass) + 1

        while i < len(mro):
            kls = mro[i]

            if hasattr(kls, attr):
                res = getattr(kls, attr)
                if hasattr(res, "__get__"):
                    res = res.__get__(self.obj, self.objclass)
                return res

            i += 1

        raise AttributeError()

