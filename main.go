package main

import (
	"github.com/hashicorp/terraform-plugin-sdk/plugin"
	"github.com/mirelia/terraform-provider-regions/dnsimple"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: dnsimple.Provider})
}
