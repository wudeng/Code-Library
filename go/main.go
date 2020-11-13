package main

import (
	"fmt"

	"gitlab.alibaba-inc.com/gserver/srpc/codec"
)

type AckRequest struct {
	Id string `json:"id"`
}

func main() {
	var c codec.JsonCodec
	ack := AckRequest{
		Id: "hello",
	}
	data, _ := c.Encode(ack)
	fmt.Println(data)
	var d AckRequest
	c.Decode(data, &d)
	fmt.Println(d)
}
