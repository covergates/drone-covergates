package config

import (
	"log"

	"github.com/kelseyhightower/envconfig"
)

// Config plugin
type Config struct {
	URL        string `default:"https://covergates.com/api/v1" envconfig:"PLUGIN_API_URL"`
	Token      string `envconfig:"PLUGIN_TOKEN"`
	ReportID   string `envconfig:"PLUGIN_REPORT_ID"`
	ReportType string `envconfig:"PLUGIN_TYPE"`
	Report     string `envconfig:"PLUGIN_REPORT"`
	Comment    bool   `envconfig:"PLUGIN_COMMENT"`
}

// Environ to config
func Environ() *Config {
	cfg := &Config{}
	if err := envconfig.Process("", cfg); err != nil {
		log.Fatal(err)
	}
	return cfg
}
