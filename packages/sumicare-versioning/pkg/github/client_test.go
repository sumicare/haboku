//
// Copyright (c) 2025 Sumicare
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//nolint:errcheck // test file - error checking handled by test assertions
package github

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("GitHub Client", func() {
	It("NewClient creates client", func() {
		c := NewClient()
		Expect(c.httpClient).NotTo(BeNil())
		Expect(c.apiURL).To(Equal("https://api.github.com"))
	})

	DescribeTable("GetOwnerRepoFrom",
		func(url, owner, repo string) {
			o, r := GetOwnerRepoFrom(url)
			Expect(o).To(Equal(owner))
			Expect(r).To(Equal(repo))
		},
		Entry("HTTPS", "https://github.com/k8s/k8s.git", "k8s", "k8s"),
		Entry("SSH", "git@github.com:k8s/k8s.git", "k8s", "k8s"),
		Entry("invalid", "invalid", "", ""),
	)

	It("parseNextLink extracts next URL", func() {
		Expect(parseNextLink(`<http://x>; rel="next"`)).To(Equal("http://x"))
		Expect(parseNextLink(`<http://x>; rel="last"`)).To(BeEmpty())
		Expect(parseNextLink("")).To(BeEmpty())
	})

	It("fetchPageByURL handles all cases", func() {
		server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			Expect(r.Header.Get("Authorization")).To(Equal("Bearer tok"))
			w.Header().Set("Link", `<http://next>; rel="next"`)
			json.NewEncoder(w).Encode(map[string]string{"k": "v"})
		}))
		defer server.Close()

		client := NewClient()
		var result map[string]string
		next, _ := client.fetchPageByURL(server.URL, "tok", &result)
		Expect(result["k"]).To(Equal("v"))
		Expect(next).To(Equal("http://next"))

		// HTTP error
		errServer := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
			w.WriteHeader(http.StatusNotFound)
		}))
		defer errServer.Close()
		_, err := client.fetchPageByURL(errServer.URL, "", &result)
		Expect(err).To(HaveOccurred())

		// Invalid JSON
		jsonServer := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
			w.Write([]byte("bad"))
		}))
		defer jsonServer.Close()
		_, err = client.fetchPageByURL(jsonServer.URL, "", &result)
		Expect(err).To(HaveOccurred())

		// Network error
		_, err = client.fetchPageByURL("http://localhost:1", "", &result)
		Expect(err).To(HaveOccurred())
	})

	It("fetchAll handles pagination and errors", func() {
		calls := 0
		var serverURL string
		server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			calls++
			if calls == 1 {
				w.Header().Set("Link", `<`+serverURL+r.URL.String()+`>; rel="next"`)
			}
			json.NewEncoder(w).Encode([]json.RawMessage{[]byte(`"a"`), []byte(`"b"`)})
		}))
		defer server.Close()
		serverURL = server.URL

		client := &Client{httpClient: server.Client(), apiURL: server.URL}
		limit := 3
		items, _ := client.fetchAll("o", "r", "tags", "", &limit)
		Expect(items).To(HaveLen(3))

		limit = 0
		items, _ = client.fetchAll("o", "r", "tags", "", &limit)
		Expect(items).To(BeEmpty())

		emptyServer := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
			json.NewEncoder(w).Encode(make([]json.RawMessage, 0))
		}))
		defer emptyServer.Close()
		client = &Client{httpClient: emptyServer.Client(), apiURL: emptyServer.URL}
		items, _ = client.fetchAll("o", "r", "tags", "", nil)
		Expect(items).To(BeEmpty())

		client = &Client{httpClient: http.DefaultClient, apiURL: "http://localhost:1"}
		_, err := client.fetchAll("o", "r", "tags", "", nil)
		Expect(err).To(HaveOccurred())
	})

	It("GetReleases and GetTags fetch and sort", func() {
		relServer := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
			json.NewEncoder(w).Encode([]GitReleaseResponse{{TagName: "v1.0.0"}, {TagName: "v2.0.0"}})
		}))
		defer relServer.Close()

		client := &Client{httpClient: relServer.Client(), apiURL: relServer.URL}
		tags, _ := client.GetReleases("https://github.com/o/r", "", nil)
		Expect(tags).To(Equal([]string{"v2.0.0", "v1.0.0"}))

		tagServer := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
			json.NewEncoder(w).Encode([]GitTagsResponse{{Ref: "refs/tags/v1.0.0"}, {Ref: "refs/tags/v2.0.0"}})
		}))
		defer tagServer.Close()

		client = &Client{httpClient: tagServer.Client(), apiURL: tagServer.URL}
		tags, _ = client.GetTags("https://github.com/o/r", "", nil)
		Expect(tags).To(Equal([]string{"v2.0.0", "v1.0.0"}))

		// Invalid URL
		client = NewClient()
		_, err := client.GetReleases("invalid", "", nil)
		Expect(err).To(HaveOccurred())
		_, err = client.GetTags("invalid", "", nil)
		Expect(err).To(HaveOccurred())

		// Network error
		client = &Client{httpClient: http.DefaultClient, apiURL: "http://localhost:1"}
		_, err = client.GetReleases("https://github.com/o/r", "", nil)
		Expect(err).To(HaveOccurred())
		_, err = client.GetTags("https://github.com/o/r", "", nil)
		Expect(err).To(HaveOccurred())
	})
})
