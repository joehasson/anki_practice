from bintree import Tree

def traverse(T: Tree | None) -> list[int]:
    result = []
    stack: list[Tree] = []

    if T is None:
        return []

    while stack or T:
        if T:
            stack.append(T)
            if T.right:
                T = T.right
            elif T.left:
                T = T.left
        else:
            T = stack.pop()
            result.append(T.label)

    return result

