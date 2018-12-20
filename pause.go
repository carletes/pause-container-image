package main

import (
	"fmt"
	"os"
	"os/signal"

	"golang.org/x/sys/unix"
)

func main() {
	// Ensure termination signals are handled when we're PID 1.
	c := make(chan os.Signal, 1)
	signal.Notify(c, unix.SIGHUP, unix.SIGINT, unix.SIGTERM, unix.SIGQUIT)
	go func(c chan os.Signal) {
		s := <-c
		fmt.Fprintf(os.Stderr, "Shutting down, got signal: %v\n", s)
		os.Exit(0)
	}(c)

	unix.Pause()
}
