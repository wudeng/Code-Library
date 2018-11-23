package main

import (
	"flag"
	"fmt"
	"strings"
)

type OptionsFlag struct {
	set     bool
	options []string
}

func (o *OptionsFlag) String() string {
	return fmt.Sprint(o.options)
}

func (o *OptionsFlag) Set(value string) error {
	o.set = true
	o.options = strings.Split(value, ",")
	return nil
}

func main() {
	var tcp OptionsFlag
	var kcp OptionsFlag
	flag.Var(&tcp, "tcp", "tcp options")
	flag.Var(&kcp, "kcp", "kcp options")
	flag.Parse()

	fmt.Println("tcp:", tcp.set)
	fmt.Println("kcp:", kcp.set)
}
