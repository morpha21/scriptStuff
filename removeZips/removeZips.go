package main

import (
	"io/ioutil"
	"os"
	"path/filepath"
)

//          checks if nome is in lista.

func checkin(nome string, lista []string) bool {
	for _, i := range lista {
		if i == nome {
			return true
		}
	}
	return false
}

func main() {
	for _, path := range os.Args[1:] {

		files, _ := ioutil.ReadDir(path)
		zips := make([]string, 0)
		folders := make([]string, 0)

		for _, f := range files {
			if filepath.Ext(f.Name()) == ".zip" {
				zips = append(zips, f.Name())
			} else {
				folders = append(folders, f.Name())
			}
		}

		for _, folder := range folders {
			if checkin(folder+".zip", zips) {
				os.Remove(path + folder + ".zip")
			}
		}
	}
}
