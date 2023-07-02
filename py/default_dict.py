class  MyDefaultDict(dict):
    def __init__(self, default_factory, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.f = default_factory

    def __missing__(self, k):
        val = self.f()
        self[k] = val
        return val
