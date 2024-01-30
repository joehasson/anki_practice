import threading
import dataclasses

@dataclasses.dataclass
class Shared:
    mutex: threading.Semaphore
    turnstile: threading.Semaphore
    turnstile2: threading.Semaphore
    threadcount: int
    counter: int = 0
    lst: list[int] = dataclasses.field(default_factory=list) 

def thread_code(shared: Shared):
    for i in range(1000):
        # Pre-amble
        shared.mutex.acquire()
        shared.lst.append(i)
        shared.mutex.release()

        # Turnstile 1
        shared.mutex.acquire()
        shared.counter += 1
        if shared.counter == shared.threadcount:
            shared.turnstile.release() # unlock the first turnstile
            shared.turnstile2.acquire() # lock the second turnstile
        shared.mutex.release()

        shared.turnstile.acquire()
        shared.turnstile.release()

        # Critical section
        shared.mutex.acquire()
        shared.lst.append(i+1)
        shared.mutex.release()

        # Turnstile 2
        shared.mutex.acquire()
        shared.counter -= 1
        if shared.counter == 0:
            shared.turnstile.acquire() # lock the first turnstile
            shared.turnstile2.release() # unlock the second turnstile
        shared.mutex.release()

        shared.turnstile2.acquire()
        shared.turnstile2.release()


if __name__ == "__main__":
    threadcount = 100
    shared = Shared(
            turnstile=threading.Semaphore(0), 
            turnstile2=threading.Semaphore(1), 
            mutex=threading.Semaphore(1), 
            threadcount=threadcount
    )

    threads = [threading.Thread(target=thread_code, args=(shared,)) for _ in range(threadcount)]

    for t in threads: t.start()
    for t in threads: t.join()

    print(shared.lst == sorted(shared.lst))

