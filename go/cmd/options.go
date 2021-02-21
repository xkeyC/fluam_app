package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/path_provider"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(1220, 740),
	flutter.WindowDimensionLimits(1220, 740, 1920, 1080),
	flutter.AddPlugin(&path_provider.PathProviderPlugin{
		VendorName:      "cn.xkeyc.fluam",
		ApplicationName: "fluam",
	}),
}
