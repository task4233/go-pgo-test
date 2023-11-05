package main

import (
	"bytes"
	"flag"
	"fmt"
	"io"
	"log"
	"math"
	"net/http"
	"os"

	_ "net/http/pprof"
)

var (
	source = flag.String("source", "./assets/icon.png", "path to png image file to upload")
	addr   = flag.String("addr", "http://localhost:8080", "address of server")

	count = flag.Int("count", math.MaxInt, "Number of requests to send")
	quit  = flag.Bool("quit", false, "Send /quit request after sending all requests")
)

// generateLoad sends count requests to the server.
func generateLoad(count int) error {
	if *addr == "" {
		return fmt.Errorf("-addr must be set to the address of the server (e.g., http://localhost:8080)")
	}

	src, err := os.ReadFile(*source)
	if err != nil {
		return fmt.Errorf("failed os.ReadFile: %w", err)
	}
	reader := bytes.NewReader(src)

	requestURL := fmt.Sprintf("%s/convert/png", *addr)

	for i := 0; i < count; i++ {
		resp, err := http.Post(requestURL, "application/octet-stream", reader)
		if err != nil {
			return fmt.Errorf("failed http.Post: %w", err)
		}
		if _, err := io.Copy(io.Discard, resp.Body); err != nil {
			return fmt.Errorf("failed io.Copy: %w", err)
		}
		resp.Body.Close()
	}

	return nil
}

func main() {
	flag.Parse()

	log.Printf("test starts with source: %v, count: %d, quit: %v\n", *source, *count, *quit)

	if err := generateLoad(*count); err != nil {
		log.Printf("failed generateLoad: %v", err)
		os.Exit(1)
	}

	if *quit {
		http.Get(*addr + "/quit")
	}
}
