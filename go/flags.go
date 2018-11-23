package main

import (
	"flag"
	"fmt"
)

func main() {
	var common int
	var fec int
	flag.IntVar(&common, "common", 0, "common")
	kcp := flag.NewFlagSet("kcp", flag.ExitOnError)
	kcp.IntVar(&fec, "fec", 0, "fec")
	flag.Parse()

	args := flag.Args()
	kcp.Parse(args[1:])

	fmt.Printf("args = %v\n", args)
	fmt.Printf("common = %v\n", common)
	fmt.Printf("fec = %v\n", fec)
}
