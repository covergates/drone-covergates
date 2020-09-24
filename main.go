package main

import (
	"log"
	"os"

	"github.com/covergates/covergates/cmd/cli/comment"
	"github.com/covergates/covergates/cmd/cli/upload"
	"github.com/covergates/drone-covergates/config"
	"github.com/urfave/cli/v2"
)

var (
	// CoverGatesAPI to covergates API URL
	CoverGatesAPI = "https://covergates.com/api/v1"
	// Version of cli
	Version = "0.0"
)

var app = &cli.App{
	Name:    "covergate",
	Version: Version,
	Commands: []*cli.Command{
		upload.Command,
		comment.Command,
	},
	Flags: []cli.Flag{
		&cli.StringFlag{
			Name:    "token",
			Usage:   "provide OAuth token for API",
			EnvVars: []string{"GATES_TOKEN"},
		},
		&cli.StringFlag{
			Name:    "url",
			Value:   CoverGatesAPI,
			Usage:   "api service url",
			EnvVars: []string{"API_URL"},
		},
	},
}

func main() {
	cfg := config.Environ()
	os.Setenv("API_URL", cfg.URL)
	os.Setenv("REPORT_ID", cfg.ReportID)
	os.Setenv("GATES_TOKEN", cfg.Token)

	args := append(os.Args[0:1], []string{"upload", "--type", cfg.ReportType, cfg.Report}...)
	if err := app.Run(args); err != nil {
		log.Fatal(err)
	}
	if cfg.Comment {
		args := append(os.Args[0:1], []string{"comment"}...)
		if err := app.Run(args); err != nil {
			log.Fatal(err)
		}
	}
	os.Exit(0)
}
