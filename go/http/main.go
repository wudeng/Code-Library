package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

type TwtBuild struct {
	RepoName string `json:"repo_name"`
	RefType  string `json:"ref_type"`
	Ref      string `json:"ref"`
	Upload   bool   `json:"upload"`
}

type BuildResp struct {
	Code string    `json:"code"`
	Data BuildData `json:"data"`
}

type BuildData struct {
	Package Package `json:"package"`
}

type Package struct {
	Name string `json:"name"`
}

func main() {
	fmt.Println("vim-go")
	url := "http://127.0.0.1:8297/test"
	params := &TwtBuild{
		RepoName: "s3server",
		RefType:  "branch",
		Ref:      "master",
		Upload:   true,
	}
	buf := new(bytes.Buffer)
	json.NewEncoder(buf).Encode(params)

	//var jsonStr = []byte(`{"name":"wudeng"}`)
	req, err := http.NewRequest("POST", url, buf)
	req.Header.Set("Content-Type", "application/json")
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	fmt.Println("response status:", resp.Status)
	fmt.Println("response Headers:", resp.Header)
	body, _ := ioutil.ReadAll(resp.Body)
	fmt.Println("response Body:", string(body))
}
