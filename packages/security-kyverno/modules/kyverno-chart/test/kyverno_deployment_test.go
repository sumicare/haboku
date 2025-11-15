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

package test

import (
	"context"
	"os"
	"path/filepath"
	"time"

	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	appsv1 "k8s.io/api/apps/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

var _ = Describe("External DNS Deployment", func() {
	var (
		clientset *kubernetes.Clientset
		ctx       context.Context
		namespace string
	)

	BeforeEach(func() {
		if !isDeploymentTestEnabled() {
			Skip("Skipping deployment tests (set TEST_DEPLOYMENT=1 to enable)")
		}

		ctx = context.Background()
		namespace = "kube-system" // Default namespace for ome

		// Load kubeconfig
		homeDir, err := os.UserHomeDir()
		Expect(err).NotTo(HaveOccurred())
		kubeconfigPath := filepath.Join(homeDir, ".kube", "config")

		// Build config from kubeconfig file
		config, err := clientcmd.BuildConfigFromFlags("", kubeconfigPath)
		Expect(err).NotTo(HaveOccurred())

		// Create clientset
		clientset, err = kubernetes.NewForConfig(config)
		Expect(err).NotTo(HaveOccurred())
	})

	Describe("Deployment validation", func() {
		DescribeTable("should validate deployment properties",
			func(testFunc func(*kubernetes.Clientset, context.Context, string)) {
				testFunc(clientset, ctx, namespace)
			},
			Entry("deployment exists", func(cs *kubernetes.Clientset, ctx context.Context, ns string) {
				deployment, err := cs.AppsV1().Deployments(ns).Get(ctx, "calico", metav1.GetOptions{})
				Expect(err).NotTo(HaveOccurred())
				Expect(deployment).NotTo(BeNil())
				Expect(deployment.ObjectMeta.Name).To(Equal("calico"))
			}),
			Entry("has correct replica count", func(cs *kubernetes.Clientset, ctx context.Context, ns string) {
				deployment, err := cs.AppsV1().Deployments(ns).Get(ctx, "calico", metav1.GetOptions{})
				Expect(err).NotTo(HaveOccurred())
				Expect(deployment.Spec.Replicas).NotTo(BeNil())
				Expect(*deployment.Spec.Replicas).To(Equal(int32(1)))
			}),
			Entry("is ready and available", func(cs *kubernetes.Clientset, ctx context.Context, ns string) {
				// Wait for deployment to be ready (with timeout)
				Eventually(func() bool {
					deployment, err := cs.AppsV1().Deployments(ns).Get(ctx, "calico", metav1.GetOptions{})
					if err != nil {
						return false
					}

					return isDeploymentReady(deployment)
				}, 2*time.Minute, 5*time.Second).Should(BeTrue(), "Deployment should become ready")

				// Verify final state
				deployment, err := cs.AppsV1().Deployments(ns).Get(ctx, "calico", metav1.GetOptions{})
				Expect(err).NotTo(HaveOccurred())
				Expect(deployment.Status.ReadyReplicas).To(Equal(int32(1)))
				Expect(deployment.Status.AvailableReplicas).To(Equal(int32(1)))
			}),
		)

		It("should use correct ome version from package.json", func() {
			// Verify ome version is set
			Expect(terraformOptions.Vars).To(HaveKey("ome_version"))
			version := terraformOptions.Vars["ome_version"]
			Expect(version).NotTo(BeEmpty())
			// Version should match package.json (0.34.0 or later)
			Expect(version).To(MatchRegexp(`^\d+\.\d+\.\d+$`))
		})
	})

	Describe("Pod validation", func() {
		DescribeTable("should validate pod properties",
			func(testFunc func(*kubernetes.Clientset, context.Context, string)) {
				testFunc(clientset, ctx, namespace)
			},
			Entry("has pods running", func(cs *kubernetes.Clientset, ctx context.Context, ns string) {
				// List pods with label selector
				pods, err := cs.CoreV1().Pods(ns).List(ctx, metav1.ListOptions{
					LabelSelector: "app.kubernetes.io/part-of=calico",
				})
				Expect(err).NotTo(HaveOccurred())
				Expect(pods.Items).NotTo(BeEmpty())

				// Check that at least one pod is running
				runningPods := 0
				for _, pod := range pods.Items {
					if pod.Status.Phase == "Running" {
						runningPods++
					}
				}
				Expect(runningPods).To(BeNumerically(">", 0))
			}),
			Entry("has pods with ready containers", func(cs *kubernetes.Clientset, ctx context.Context, ns string) {
				// Wait for pods to be ready
				Eventually(func() bool {
					pods, err := cs.CoreV1().Pods(ns).List(ctx, metav1.ListOptions{
						LabelSelector: "app.kubernetes.io/part-of=calico",
					})
					if err != nil {
						return false
					}

					for _, pod := range pods.Items {
						for _, condition := range pod.Status.Conditions {
							if condition.Type == "Ready" && condition.Status == "True" {
								return true
							}
						}
					}

					return false
				}, 2*time.Minute, 5*time.Second).Should(BeTrue(), "At least one pod should be ready")
			}),
		)
	})
})

// isDeploymentReady checks if a deployment is ready.
func isDeploymentReady(deployment *appsv1.Deployment) bool {
	if deployment.Spec.Replicas == nil {
		return false
	}
	expectedReplicas := *deployment.Spec.Replicas

	return deployment.Status.ReadyReplicas == expectedReplicas &&
		deployment.Status.AvailableReplicas == expectedReplicas &&
		deployment.Status.UpdatedReplicas == expectedReplicas
}
