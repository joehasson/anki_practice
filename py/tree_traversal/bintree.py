from __future__ import annotations

import dataclasses

@dataclasses.dataclass
class Tree:
    label: int
    left: Tree | None
    right: Tree | None

