package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	arquivo := "/sys/class/backlight/amdgpu_bl0/brightness"

	content, err := ioutil.ReadFile(arquivo)
	check(err)
	luztemp, _ := strconv.Atoi(string(content)[:len(content)-1])
	var luz int16 = int16(luztemp)

	if os.Args[1] == "mais" {
		luz += 21
		if luz > 255 {
			luz = 255
		}
	} else if os.Args[1] == "menas" {
		luz -= 12
		if luz < 0 {
			luz = 0
		}
	}

	f, err := os.Create(arquivo)
	check(err)
	defer f.Close()

	_, err = f.WriteString(strconv.Itoa(int(luz)) + "\n")
	check(err)

	fmt.Println(luz)
}
