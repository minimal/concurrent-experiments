package main

import "fmt"

func main() {
    numbers := make(chan int)
    stringchan := make(chan string)

    go func() {
        a := <-numbers
        b := <-numbers
        c := <-numbers
        stringchan <- fmt.Sprintf("%d + %d + %d = %d", a, b, c, a+b+c)
    }()

    go func() { numbers <- 2 * 10 }()
    go func() { numbers <- 2 * 20 }()
    go func() { numbers <- 30 + 40 }()

    fmt.Println(<-stringchan)
}
