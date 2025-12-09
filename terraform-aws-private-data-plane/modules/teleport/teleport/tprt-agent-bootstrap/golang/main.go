package main

import (
	"bytes"
	b64 "encoding/base64"
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"text/template"
)

type TeleportChanges struct {
	TeleportNonAdHosts  []string
	TeleportCluster     string
	TeleportProxyUri    string
	TeleportToken       string
	LabelKey            string
	LabelVal            string
	TeleportLabels      map[string]string
	TeleportEksEnabled  bool
	TeleportAppName     string
	TeleportEksHostName string
}

// applyReplacements for teleport templates
func applyReplacement(data string, windowsHosts []string, teleportLabels map[string]string, eksEnabled bool) (string, error) {
	var globalTmpl = template.Must(template.New("replacements").Parse(data))

	labelKey := os.Getenv("TELEPORT_LABELKEY")

	labelVal := os.Getenv("TELEPORT_LABELKEY")

	teleportChanges := TeleportChanges{TeleportNonAdHosts: windowsHosts,
		TeleportCluster:     os.Getenv("TELEPORT_CLUSTER"),
		TeleportProxyUri:    os.Getenv("TELEPORT_PROXY_URI"),
		TeleportToken:       os.Getenv("TELEPORT_TOKEN"),
		LabelKey:            labelKey,
		LabelVal:            labelVal,
		TeleportLabels:      teleportLabels,
		TeleportEksEnabled:  eksEnabled,
		TeleportAppName:     os.Getenv("TELEPORT_APP_NAME"),
		TeleportEksHostName: os.Getenv("TELEPORT_EKS_HOSTNAME"),
	}

	w := &bytes.Buffer{}
	if err := globalTmpl.Execute(w, teleportChanges); err != nil {
		fmt.Print(err)
		return data, err
	}

	return w.String(), nil
}

func main() {
	//myJsonString := `[{"labelkey1":"value"}, {"labelkey2":"value4"}, {"labelkey9":"value3"}]`
	//b64Encoded := "eyJsYWJlbGtleTEiOiJ2YWx1ZSIsICJsYWJlbGtleTIiOiJ2YWx1ZTQiLCAibGFiZWxrZXk5IjoidmFsdWUzIn0K"

	myJsonString, _ := b64.StdEncoding.DecodeString(os.Getenv("TELEPORT_LABELS"))

	var teleportLabels map[string]string
	json.Unmarshal([]byte(myJsonString), &teleportLabels)

	ips := []string{}

	eksEnabled, _ := strconv.ParseBool(os.Getenv("TELEPORT_EKS_ENABLED"))
	teleportAgentConfig, _ := os.ReadFile("teleport.yml")
	teleportConfig := string(teleportAgentConfig)
	replaced, _ := applyReplacement(teleportConfig, ips, teleportLabels, eksEnabled)
	fmt.Print(replaced)
}
