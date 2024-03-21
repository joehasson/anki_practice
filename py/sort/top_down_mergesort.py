def sort(A: list[int]) -> list[int]:
    length = len(A)
    if length <= 1:
        return A
    else:
        mid = len(A) // 2
        l, r = sort(A[:mid]), sort(A[mid:])
        return merge(l,r)


def merge(l: list[int], r: list[int]) -> list[int]:
    merged = []
    lp, rp = 0, 0
    len_l, len_r = len(l), len(r)

    while lp < len_l and rp < len_r:
        lv, rv = l[lp], r[rp]
        if lv <= rv:
            merged.append(lv)
            lp += 1
        else:
            merged.append(rv)
            rp += 1

    merged.extend(l)
    merged.extend(r)

    return merged

