locals {
  install_sh = templatefile("${path.module}/templates/install.sh.tftpl", {
    hostname            = var.hostname,
    api_key             = var.api_key,
    site                = var.site,
    sidescanner_version = var.sidescanner_version,
    agent_repo_url      = var.agent_repo_url,
  })
}
