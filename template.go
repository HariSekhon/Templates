//  vim:ts=4:sts=4:sw=4:noet
//
//  Author: Hari Sekhon
//  Date: [% DATE %]
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
	"log"
	log "github.com/sirupsen/logrus"
	"os"
	"sort"
	"strconv"
	"strings"
)

func readline() string {
	in := bufio.NewReader(os.Stdin)
	line, err := in.ReadString('\n')
	if err != nil {
		log.Fatal(err)
	}
	line = strings.TrimSpace(line)
	return line
}

func prompt_float(msg string) float64 {
	fmt.Printf("%s: ", msg)
	in := bufio.NewReader(os.Stdin)
	line, err := in.ReadString('\n')
	if err != nil {
		log.Fatal(err)
	}
	line = strings.TrimSpace(line)
	user_float, err := strconv.ParseFloat(line, 64)
	if err != nil {
		log.Fatal(err)
	}
	return user_float
}

func list_to_slice(list []int) []int {
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
	if os.Getenv("DEBUG") != "" {
		log.Printf("debug logging enabled")
	}
	log.Println("starting main()")
	fmt.Printf("Enter a string: ")
	line := readline()
	list := strings.Split(line, " ")

	name_address := map[string]string{"name": name, "address": address}
	json_data, err := json.Marshal(name_address)

	filehandle, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer filehandle.Close()
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
