package main

import (
	"errors"
	"log"
	"net/http"
	_ "net/http/pprof"
	"os"
	"runtime"
	"runtime/pprof"

	"github.com/task4233/pgo-test/converter"
)

func convertHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/octet-stream")

	c := converter.GetConverter(r.URL.Path)
	if err := c.Convert(w, r.Body); err != nil {
		if errors.Is(err, converter.ErrDecode) {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}
		r.Body.Close()
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func main() {
	// ready cpu profile
	f, err := os.Create("profile/cpu.pprof")
	if err != nil {
		log.Printf("failed to create: %v", err)
		os.Exit(1)
	}
	if err := pprof.StartCPUProfile(f); err != nil {
		log.Printf("failed to create: %v", err)
		os.Exit(1)
	}

	// finish profiling on giving /quit request
	http.HandleFunc("/quit", func(w http.ResponseWriter, r *http.Request) {
		pprof.StopCPUProfile()
		f.Close()

		f, err := os.Create("profile/heap.pprof")
		if err != nil {
			panic(err)
		}
		runtime.GC()
		if err := pprof.WriteHeapProfile(f); err != nil {
			panic(err)
		}
		f.Close()

		os.Exit(0)
	})

	// register /convert endpoint
	http.HandleFunc(converter.PathPrefix, convertHandler)

	log.Printf("Serving on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
