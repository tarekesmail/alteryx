resource "kubernetes_secret" "pdp_argocd_bootstrap_private" {
  metadata {
    name      = "cluster-autoregister-aws-${var.resource_name}"
    namespace = "argocd-bender"
    annotations = {
      "managed-by" = "argocd.argoproj.io"
    }
    labels = merge(
      var.CLUSTER_REGISTRATION,
      // ensure the following ones are always presents
      tomap({
        "argocd.argoproj.io/secret-type" = "cluster"
        "cloud"                          = "${var.CLUSTER_REGISTRATION.cloud}"
      }),
    )
  }
  data = {
    name   = var.pdp_eks_name
    server = "https://pdp-aws-k8sapi-${var.pdp_eks_name}.teleport-machineid.svc.cluster.local:8443"
    config = jsonencode({
      execProviderConfig = {
        apiVersion = "client.authentication.k8s.io/v1beta1"
        command    = "argocd-k8s-auth"
        args = [
          "aws",
          "--cluster-name",
          var.pdp_eks_name
        ]
        env = {
          AWS_ACCESS_KEY_ID     = var.AWS_ACCESS_KEY_ID
          AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
          AWS_DEFAULT_REGION    = var.AWS_DATAPLANE_REGION
        }
      }
      tlsClientConfig = {
        insecure = true
      }
    })
  }
  type = "Opaque"
  depends_on = [
    shell_script.teleport_finalizer_cleanup
  ]
  provider = kubernetes.cp
}