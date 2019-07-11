package main

import (
	"flag"
	"net"
	"strconv"
	"strings"
)

type setReadBuffer interface {
	SetReadBuffer(bytes int) error
}

type setWriteBuffer interface {
	SetWriteBuffer(bytes int) error
}

var address string

func init() {
	flag.StringVar(&address, "addr", ":8181", "Address of the UDP server to test")
}

// var total int

func main() {
	flag.Parse()
	c, err := net.ListenPacket("udp", address)
	if err != nil {
		println("error")
	}
	defer c.Close()
	if nc, ok := c.(setReadBuffer); ok {
		nc.SetReadBuffer(67108864)
	}
	msg := make([]byte, 1500)
	for {
		_, from, err := c.ReadFrom(msg)
		ip := from.String()
		addrs := strings.Split(ip, ":")

		println(from.String())
		n, _ := strconv.Atoi(addrs[len(addrs)-1])
		println(n % 100)
		if err != nil {
			println("error")
		}
	}
	// print(total)
}
