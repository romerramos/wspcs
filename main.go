// Package main implements a workspace manager that creates tmux sessions
// based on YAML configuration files for development environments.
package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"romerramos/wspcs/config"
	"romerramos/wspcs/tmux"
)

func main() {
	filename := flag.String("f", "", "Workspace configuration file")
	flag.Parse()
	if *filename == "" {
		flag.Usage()
		os.Exit(1)
	}

	w, err := config.GetWorkspace(*filename)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Workspace Name: %s\n", w.Name)

	path, err := exec.LookPath("tmux")
	if err != nil {
		log.Fatal("tmux is not installed or not found in PATH")
	}

	cmd := exec.Command(path, "-V")
	if err := cmd.Run(); err != nil {
		log.Fatal("tmux is not executable:", err)
	}

	session := tmux.NewSession(w.Name)
	if session.Exists() {
		fmt.Printf("Session %s already exists. Attaching...\n", w.Name)
		if err := session.Attach(); err != nil {
			log.Fatal("Failed to attach to session:", err)
		}
		return
	}

	fmt.Printf("Creating new session: %s\n", w.Name)
	if err := session.Create(); err != nil {
		log.Fatal("Failed to create session:", err)
	}

	for _, project := range w.Projects {
		if _, err := os.Stat(project.Path); err != nil {
			log.Printf("Failed to find path %s: %v", project.Path, err)
			continue
		}

		if err := session.NewWindow(project.Name, project.Path); err != nil {
			log.Printf("Failed to create window for project %s: %v", project.Name, err)
		}
		if err := session.SplitWindowVertical(project.Name, 1, 25, project.Path); err != nil {
			log.Printf("Failed to split window for project %s: %v", project.Name, err)
		}
		if err := session.SendKeys(project.Name, 2, "clear"); err != nil {
			log.Printf("Failed to clear terminal on project %s: %v", project.Name, err)
		}
		if err := session.SendKeys(project.Name, 1, "nvim ."); err != nil {
			log.Printf("Failed to run nvim on %s: %v", project.Name, err)
		}
	}

	if err := session.Attach(); err != nil {
		log.Fatal("Failed to attach to session:", err)
	}
}
