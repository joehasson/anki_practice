import pytest

from default_dict import MyDefaultDict

@pytest.fixture
def dic():
    d = MyDefaultDict(a=1, b=2, default_factory=set)
    return d

def test_is_dictionary(dic):
    assert dic == {'a': 1, 'b': 2}

def test_create_default(dic):
    assert dic['c'] == set()

def test_factory(dic):
    assert dic['c'] is not dic['d']
