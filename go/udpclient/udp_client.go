package main

import (
	"flag"
	"net"
	"strings"
	"time"
)

var address string
var pps int

func init() {
	flag.StringVar(&address, "addr", ":8181", "Address of the UDP server to test")
	flag.IntVar(&pps, "pps", 100000, "PPS")
}

func main() {
	flag.Parse()
	println(address)
	c, err := net.ListenUDP("udp", nil)
	udpaddr, err := net.ResolveUDPAddr("udp", address)
	if err != nil {
		println("error")
	}
	defer c.Close()
	ticker := time.NewTicker(1 * time.Millisecond)
	defer ticker.Stop()
	msg := strings.Repeat("hello", 20)
	pps /= 1000
	for range ticker.C {
		for i := 0; i < pps; i++ {
			c.WriteTo([]byte(msg), udpaddr)
		}
	}
}
