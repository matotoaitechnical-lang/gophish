package main

// CSRFExemptPrefixes are a list of routes that are exempt from CSRF protection
var CSRFExemptPrefixes = []string{
    "/api",
    "/login", 
    "/logout",
    "/reset_password",
    "/forgot",
    "/",  // Add root path if needed
}
