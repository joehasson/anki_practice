#include <aio.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Generic type definition for a custom allocator */
typedef struct {
    void *(*alloc)(void *context, size_t bytes);
    void (*free)(void *context, void *ptr);
    void *(*realloc)(void *context, void *ptr, size_t old_size, size_t new_size);
    void *context;
} Allocator;

/* Malloc-based allocator */
void *my_malloc(void *context, size_t bytes) { return malloc(bytes); }
void my_mfree(void *context, void *ptr) { free(ptr); }
void *my_mrealloc(void *context, void *ptr, size_t old_size, size_t new_size) {
    return realloc(ptr, new_size);
}

/* Linear // arena allocator */
typedef struct {
    void *buf;
    size_t buflen;
    size_t prev_offset;
    size_t offset;
} Arena;

/* Allocate some memory */
void *arena_alloc(void *context, size_t bytes) {
    Arena *arena = (void *) context;
    /* Check if have enough memory - return NULL if not */
    if (arena->offset + bytes > arena->buflen) {
        return NULL;
    }
    void *ptr = arena->buf + arena->offset;
    arena->prev_offset = arena->offset;
    arena->offset += bytes;
    return ptr;
}

/* If the pointer is the last-allocated thing, resize the offset.
 * Else just call arena_alloc again for it */
void *arena_realloc(void *context, void *ptr, size_t old_size, size_t new_size) {
    Arena *arena = (Arena *) context;
    /* If ptr is null or no space allocated initial then this is equivalent to alloc */
    if (ptr == NULL || old_size == 0) { 
        return arena_alloc(arena, new_size);
    } 
    /* Happy path: ptr is within arena buffer's bounds */
    else if (arena->buf <= ptr && ptr < arena->buf + arena->buflen) {
        /* if this was the last allocated value then just change how much was allocated for it */
        if (arena->buf + arena->prev_offset == ptr) {
            arena->offset = arena->prev_offset + new_size;
            return ptr;
        } 
        /* else just allocate new memory and copy across the old memory */
        else {
            void *new_ptr = arena_alloc(arena, new_size);
            memcpy(new_ptr, ptr, old_size < new_size ? old_size : new_size);
            return new_ptr;
        }
    } 
    /* Sad path: ptr out of arena bounds */
    else {
        fprintf(stderr, "Memory out of bounds of this arena\n");
        exit(1);
    }
}

/* Initialize an Arena struct given a backing buffer */
void arena_init(Arena *a, void *backing_buf, size_t backing_buf_len) {
    a->buf = backing_buf;
    a->buflen = backing_buf_len;
    a->offset = 0;
    a->prev_offset = 0;
}

/* Doesn't do anything. We don't have the capacity to free specific
 * elements in the arena; instead we can only "free all". */
void arena_free(void *context, void *ptr) {
    return ;
}

/* Dump the entire contents of the arena */
void arena_free_all(Arena *arena) {
    arena->offset = 0;
    arena->prev_offset = 0;
}


/* Dynamic Array */
typedef struct {
    size_t length;
    size_t capacity;
    size_t padding;
    Allocator *a;
} Array_Header;

#define array_header(a) (((Array_Header *) a) - 1)

void *array_init(Allocator *a, size_t capacity, size_t item_size) {
    Array_Header *h = a->alloc(a->context, capacity * item_size + sizeof(Array_Header));
    if (h) {
        h->length = 0;
        h->capacity = capacity;
        h->a = a;
        h++;
    }
    return h;
}

/** Ensure array has room for one more element */
void *array_ensure_capacity(void *array, size_t item_size) {
    Array_Header *h = array_header(array);
    if (h->capacity < h->length + 1) {
        size_t new_capacity = h->capacity * 2;
        h = h->a->realloc(h->a->context, h, h->capacity, new_capacity);
        if (h) {
            h->capacity = new_capacity;
        }
    }
    return h ? h + 1 : NULL;
}

#define ARRAY_INITIAL_CAPACITY 16
#define array(T, alloc) array_init(alloc, ARRAY_INITIAL_CAPACITY, sizeof(T))
#define array_push(a, v) ( \
        (a) = array_ensure_capacity(a, sizeof(v)), \
        (a)[array_header(a)->length] = v, \
        &(a)[array_header(a)->length++])
#define array_pop(a) array_header(a)->length--;


void print_dynamic_array(void *a, size_t item_size) {
    Array_Header *h = array_header(a);
    printf("Length: %lu\n Capacity: %lu\n", h->length, h->capacity);
    for (int i = 0; i < h->length; i++) {
        printf("Item %d: ", i);
        for (int j = 0; j < item_size; j++) {
            char *aa = (char *) a;
            printf("%c", aa[i*item_size+j]);
        }
        printf("\n");
    }
}

/* tests */
int main() {
    Arena my_arena;
    char buf[4096];
    arena_init(&my_arena, buf, 4096);
    Allocator my_arena_allocator = {
        .alloc=arena_alloc,
        .free=arena_free,
        .realloc=arena_realloc,
        .context=&my_arena
    };

    char *b = array(char, &my_arena_allocator);
    print_dynamic_array(b, sizeof(char));
    array_push(b, 'a');
    array_push(b, 'b');
    array_push(b, 'c');
    array_push(b, 'd');
    array_push(b, 'e');
    array_push(b, 'f');
    array_push(b, 'g');
    array_push(b, 'h');
    array_push(b, 'i');
    array_push(b, 'j');
    array_push(b, 'k');
    array_push(b, 'l');
    array_push(b, 'm');
    array_push(b, 'n');
    array_push(b, 'o');
    array_push(b, 'p');
    array_push(b, 'q');
    print_dynamic_array(b, sizeof(char));
    for (int i = 0; i < 15; i++) { array_pop(b); }
    print_dynamic_array(b, sizeof(char));
}
