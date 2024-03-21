from bintree import Tree


def traverse(T: Tree | None) -> list[int]:
    result = []

    if T is None:
        return []

    stack: list[Tree] = []

    while stack or T:
        if T:
            stack.append(T)
            T = T.left
        else:
            T = stack.pop()
            result.append(T.label)
            T = T.right

    return result

