package main

import (
	"log"
	"reflect"
)

type S struct {
	X int
}

func main() {
	//i := 60
	var s S
	t := reflect.TypeOf(s)
	println(t.Name())
	k := t.Kind()
	println(k)
	log.Println("ok")
	println(reflect.Struct)
}
