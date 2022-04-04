package dnsimple

import (
	"context"

	"github.com/dnsimple/dnsimple-go/dnsimple"

	// "github.com/hashicorp/terraform-plugin-sdk/terraform"
	"log"
)

type Config struct {
	Account string
	Token   string
}

// Client represents the DNSimple provider client.
// This is a convenient container for the configuration and the underlying API client.
type Client struct {
	client *dnsimple.Client
	config *Config
}

// Client() returns a new client for accessing dnsimple.
func (c *Config) Client() (*Client, error) {
	tc := dnsimple.StaticTokenHTTPClient(context.Background(), c.Token)

	client := dnsimple.NewClient(tc)
	// TODO FIXED THIS
	// client.UserAgent = "HashiCorp-Terraform/" + terraform.VersionString()

	provider := &Client{
		client: client,
		config: c,
	}

	log.Printf("[INFO] DNSimple Client configured for account: %s", c.Account)

	return provider, nil
}
