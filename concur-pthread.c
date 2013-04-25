#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>

char result[100];

pthread_mutex_t mutex;
pthread_cond_t cond;
pthread_mutex_t set_mutex;

struct list_item {
    int val;
    struct list_item *next;
};

struct list_item *numbers;
struct list_item *last_item;

void put(int val) {
    pthread_mutex_lock(&set_mutex);
    struct list_item *newitem;
    newitem = (struct list_item*)malloc(sizeof(struct list_item));
    newitem->val = val;
    if(numbers == NULL) {
        numbers = newitem;
    } else {
        last_item->next = newitem;
    }
    last_item = newitem;
    pthread_mutex_unlock(&set_mutex);
    pthread_cond_signal(&cond);
}

int get() {
    int val;
    struct list_item *result;
    pthread_mutex_lock(&mutex);
    while(numbers == NULL) { pthread_cond_wait(&cond, &mutex); }
    pthread_mutex_lock(&set_mutex);
    result = numbers;
    numbers = result->next;
    if(numbers == NULL) {
        last_item = NULL;
    }
    val = result->val;
    free(result);
    pthread_mutex_unlock(&set_mutex);
    pthread_mutex_unlock(&mutex);
    return val;
}

void proc() {
    int x, y, z;
    x = get();
    y = get();
    z = get();
    sprintf(result, "%i + %d + %d = %d", x, y, z, x + y + z);
}

void thread1() {
    put(2 * 10);
}

void thread2() {
    put(2 * 20);
}

void thread3() {
    put(30 + 40);
}

int main() {
    pthread_t proc_thread;
    pthread_t put_threads[3];
    void* ops[] = {*thread1, thread2, thread3};
    int i;

    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&cond, NULL);
    pthread_mutex_init(&set_mutex, NULL);

    pthread_create(&proc_thread, NULL, (void*)&proc, NULL);
    for(i = 0; i < 3; i++) {
        pthread_create(&put_threads[i], NULL, (void*)ops[i], NULL);
    }
    pthread_join(proc_thread, NULL);
    puts(result);
    return 0;
}
