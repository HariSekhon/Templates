///bin/sh -c true; exec /usr/bin/env go run "$0" "$@"
//  vim:ts=4:sts=4:sw=4:noet
//
//  Author: Hari Sekhon
//  Date: [% DATE # Wed Apr 29 15:16:09 2020 +0100 %]
//
//  [% URL %]
//
//  [% LICENSE %]
//
//  [% MESSAGE %]
//
//  [% LINKEDIN %]
//

package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	//"log"
	log "github.com/sirupsen/logrus"
	"path"
	"os"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"
)

const description = `
Tool to do XXX

Tested on Mac OS X and Linux
`

var prog = path.Base(os.Args[0])

func readline() string {
	in := bufio.NewReader(os.Stdin)
	line, err := in.ReadString('\n')
	if err != nil {
		log.Fatal(err)
	}
	line = strings.TrimSpace(line)
	return line
}

func promptFloat(msg string) float64 {
	fmt.Printf("%s: ", msg)
	in := bufio.NewReader(os.Stdin)
	line, err := in.ReadString('\n')
	if err != nil {
		log.Fatal(err)
	}
	line = strings.TrimSpace(line)
	userFloat, err := strconv.ParseFloat(line, 64)
	if err != nil {
		log.Fatal(err)
	}
	return userFloat
}

func listToSlice(list []int) []int {
	slice := make([]int, 0)
	for _, v := range list {
		num, err := strconv.ParseInt(v, 10, 32) // append(slice, int) requires 32-bit ints
		if err != nil {
			fmt.Printf("ERROR: %s is not a valid integer, ignoring\n", v)
			continue
		}
		var num32 int = int(num)
		slice = append(slice, num32)
		// sort.Ints(slice)
	}
	return slice
}

func main() {
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "%s\n\nusage: %s [options]\n\n", description, prog)
		flag.PrintDefaults()
		os.Exit(3)
	}
	var debug = flag.Bool("D", false, "Debug mode")
	flag.Parse()
	if *debug || os.Getenv("DEBUG") != "" {
		log.SetLevel(log.DebugLevel)
		log.Debug("debug logging enabled")
	}
	fmt.Printf("Enter a string: ")
	line := readline()
	list := strings.Split(line, " ")

	nameAddress := map[string]string{"name": name, "address": address}
	jsonData, err := json.Marshal(nameAddress)

	if len(os.Args) > 1 {
		filename := os.Args[1]
		filehandle, err := os.Open(filename)
		if err != nil {
			//fmt.Fprintf(os.Stderr, "error: %s\n", err)
			//os.Exit(1)
			log.Fatal(err)
		}
		defer filehandle.Close()
		scanner = bufio.NewScanner(filehandle)
	} else {
		scanner = bufio.NewScanner(os.Stdin)
	}

	scanner := bufio.NewScanner(filehandle)
	for scanner.Scan() {
		line := scanner.Text()
		s := strings.Split(line, " ")
		firstname, lastname := s[0], strings.Join(s[1:], " ")
		//log.Printf("fname = %s", firstname)
		//log.Printf("lname = %s", lastname)
		p := Person{fname: firstname, lname: lastname}
		sli = append(sli, p)
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
