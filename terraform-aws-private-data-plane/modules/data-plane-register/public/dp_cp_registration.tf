resource "kubernetes_secret" "pdp_argocd_bootstrap" {
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
        "cloud"                          = "aws"
      }),
    )
  }
  data = {
    name   = var.pdp_eks_name
    server = var.dp_cluster_host
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
        insecure = false
        caData   = base64encode(var.dp_cluster_ca_cert)
      }
    })
  }
  type = "Opaque"
  depends_on = [
    shell_script.teleport_finalizer_cleanup
  ]
  provider = kubernetes.cp

}