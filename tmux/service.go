// Package tmux provides tmux session management functionality
// for creating, managing, and interacting with tmux sessions.
package tmux

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
	"syscall"
)

type Session struct {
	Name string
}

func NewSession(name string) *Session {
	return &Session{Name: name}
}

func (s *Session) run(tag bool, args ...string) (string, error) {
	fullArgs := append([]string{}, args...)
	if tag {
		fullArgs = append(fullArgs, "-t", s.Name)
	}

	cmd := exec.Command("tmux", fullArgs[0:]...)
	var stdOut, stdErr strings.Builder
	cmd.Stdout = &stdOut
	cmd.Stderr = &stdErr
	err := cmd.Run()
	if err != nil {
		return "", fmt.Errorf("tmux command failed: %v, %s", err, stdErr.String())
	}
	return stdOut.String(), nil
}

func (s *Session) Create() error {
	_, err := s.run(false, "new-session", "-d", "-s", s.Name)
	return err
}

func (s *Session) Attach() error {
	return syscall.Exec("/usr/bin/tmux", []string{"tmux", "attach-session", "-t", s.Name}, os.Environ())
}

func (s *Session) Exists() bool {
	_, err := s.run(true, "has-session")
	return err == nil
}

func (s *Session) NewWindow(name, path string) error {
	_, err := s.run(true, "new-window", "-a", "-n", name, "-c", path)
	return err
}

func (s *Session) SplitWindowVertical(windowName string, paneNumber int, size int, path string) error {
	_, err := s.run(false, "split-window", "-v",
		"-p", fmt.Sprintf("%d", size),
		"-t", fmt.Sprintf("%s:%s.%d", s.Name, windowName, paneNumber),
		"-c", path,
	)
	return err
}

func (s *Session) SendKeys(windowName string, paneNumber int, command string) error {
	_, err := s.run(false, "send-keys",
		"-t", fmt.Sprintf("%s:%s.%d", s.Name, windowName, paneNumber),
		command, "C-m",
	)
	return err
}
