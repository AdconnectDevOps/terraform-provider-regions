package main

import (
	"github.com/hashicorp/terraform/plugin"
	"github.com/terraform-provider-regions/dnsimple"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: dnsimple.Provider})
}
