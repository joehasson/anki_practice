from bintree import Tree

def traverse(T: Tree | None) -> list[int]:
    result = []

    if T is None:
        return []

    stack = [T]

    while stack:
        t = stack.pop()

        if t.right:
            stack.append(t.right)
        if t.left:
            stack.append(t.left)

        result.append(t.label)

    return result

