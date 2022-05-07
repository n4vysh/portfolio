package main

import (
	"embed"
	"io/fs"
	"net/http"
)

//go:embed dist/index.html
//go:embed dist/robots.txt
//go:embed dist/_aleph
//go:embed dist/_aleph/pages
//go:embed dist/images
//go:embed dist/keys
var indexEFS embed.FS

//go:embed dist/404/index.html
var noRouteEFS embed.FS

func convertToHFS(efs embed.FS, path string) http.FileSystem {
	sub, err := fs.Sub(efs, path)
	if err != nil {
		panic(err)
	}

	return http.FS(sub)
}
