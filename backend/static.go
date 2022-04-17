package main

import (
	"embed"
	"io/fs"
	"net/http"
)

//go:embed dist
//go:embed dist/404
//go:embed dist/_aleph
//go:embed dist/_aleph/pages
//go:embed dist/images
//go:embed dist/keys
var staticFS embed.FS

func convertFS(path string) http.FileSystem {
	sub, err := fs.Sub(staticFS, path)
	if err != nil {
		panic(err)
	}

	return http.FS(sub)
}
