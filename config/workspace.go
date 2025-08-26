// Package config provides functionality for parsing and managing
// workspace configuration files in YAML format.
package config

import (
	"fmt"
	"os"

	"gopkg.in/yaml.v3"
)

type Workspace struct {
	Name     string `yaml:"name"`
	Command  string `yaml:"command,omitempty"`
	Projects []struct {
		Name    string `yaml:"name"`
		Path    string `yaml:"path"`
		Command string `yaml:"command,omitempty"`
	}
}

func GetWorkspace(filename string) (Workspace, error) {
	content, err := os.ReadFile(filename)
	if err != nil {
		return Workspace{}, fmt.Errorf("%s file not found: %w", filename, err)
	}

	var workspace Workspace

	if err := yaml.Unmarshal([]byte(content), &workspace); err != nil {
		return Workspace{}, fmt.Errorf("failed to parse %s: %w", filename, err)
	}
	return workspace, nil
}
