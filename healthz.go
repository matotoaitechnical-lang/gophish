package main

import (
    "net/http"
)

func healthCheck(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("OK"))
}

// Add this to your main function
func init() {
    http.HandleFunc("/healthz", healthCheck)
}
