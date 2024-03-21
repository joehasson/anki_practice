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
    dancefloor: Dancefloor = Dancefloor()
    # Control shared access to the dancefloor
    mutex: threading.Semaphore = threading.Semaphore(1)
    leader_queue: threading.Semaphore = threading.Semaphore(0)
    follower_queue: threading.Semaphore = threading.Semaphore(0)
    followers: int = 0
    leaders: int = 0
    # co-ordinate exit
    rendezvous: threading.Semaphore = threading.Semaphore(0)

def leader_code(thread_id: int, shared: Shared):
    shared.mutex.acquire()
    if shared.followers > 0:
        shared.followers -= 1
        shared.follower_queue.release()
    else:
        shared.leaders += 1
        shared.mutex.release()
        shared.leader_queue.acquire()

    shared.dancefloor.dance(thread_id, "leader")
    shared.rendezvous.acquire()
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
    leader_threads = [
            threading.Thread(target=leader_code, args=(i, shared))
            for i in range(THREADCOUNT)
    ]
    follower_threads = [
            threading.Thread(target=follower_code, args=(i+THREADCOUNT, shared))
            for i in range(THREADCOUNT)
    ]
    # start in random order to be sure not just lucky
    threads = leader_threads + follower_threads
    random.shuffle(threads)

    for t in threads: t.start()
    for t in threads: t.join()

    shared.dancefloor.validate()
