import dataclasses
import random
import threading

from typing import Literal

class Dancefloor:
    def __init__(self):
        self._floor = []

    def dance(self, id: int, dancer_type: Literal["leader", "follower"]):
        if not self._floor or len(self._floor[-1]) == 2:
            self._floor.append([(dancer_type, id)])
        elif len(self._floor[-1]) == 1:
            self._floor[-1].append((dancer_type, id))

    def validate(self):
        is_valid = True
        for d1, d2 in self._floor:
            is_valid = is_valid and d1[0] != d2[0] and d1[1] != d2[1]
        print("valid" if is_valid else "invalid")


@dataclasses.dataclass
class Shared:
    # multipurpose mutex
    mutex: threading.Semaphore = threading.Semaphore(1)
    # thread queues and their sizes
    leader_queue: threading.Semaphore = threading.Semaphore(0)
    follower_queue: threading.Semaphore = threading.Semaphore(0)
    leaders: int = 0
    followers: int = 0
    # Dancefloor
    dancefloor: Dancefloor = Dancefloor()
    # check both have finished dancing before releasing mutex
    rendezvous = threading.Semaphore = threading.Semaphore(0)


def leader_code(thread_id: int, shared: Shared):
    shared.mutex.acquire()
    if shared.followers > 0:
        shared.followers -= 1
        shared.follower_queue.release() # signal a follower thread to go
    else:
        shared.leaders += 1
        shared.mutex.release()
        shared.leader_queue.acquire() # wait in the leader queue

    shared.dancefloor.dance(thread_id, "leader")
    shared.rendezvous.acquire() # wait for the follower to dance with leader
    shared.mutex.release()


def follower_code(thread_id: int, shared: Shared):
    shared.mutex.acquire()
    if shared.leaders > 0:
        shared.leaders -= 1
        shared.leader_queue.release()
    else:
        shared.followers += 1
        shared.mutex.release()
        shared.follower_queue.acquire()

    shared.dancefloor.dance(thread_id, "follower")
    shared.rendezvous.release()


if __name__ == "__main__":
    THREADCOUNT = 20_000
    shared=Shared()

    leaders = [threading.Thread(target=leader_code, args=(i, shared,)) for i in range(THREADCOUNT)]
    followers = [threading.Thread(target=follower_code, args=(THREADCOUNT+i, shared,)) for i in range(THREADCOUNT)]

    # shuffle threads to be a bit more confident solution does not just work because of
    # order in which threads were started
    threads = [*leaders, *followers]
    random.shuffle(threads)
    for t in threads:
        t.start()

    for t in threads: 
        t.join()

    shared.dancefloor.validate()

