####################################################################################################
### NAMING

locals {
  # org or org-scope
  global_prefix = var.global_prefix
  # (((var.org == var.scope) || (var.scope == "")) ? var.org : "${var.org}-${var.scope}")
  is_default_workspace = (terraform.workspace == "default") # Check if default workspace means provision environment (dev, sandbox, stag, prod)                                                                                                          # business unit
  # org-scope-env or org-scope-workspace
  id_prefix        = (local.is_default_workspace ? "${local.global_prefix}-${var.env}" : "${local.global_prefix}-${terraform.workspace}") # environment (dev, sandbox, stag, prod) or workspace
  name_prefix      = (local.is_default_workspace ? "${local.global_prefix}_${var.env}" : "${local.global_prefix}_${terraform.workspace}") # environment (dev, sandbox, stag, prod) or workspace
  role_prefix      = (local.is_default_workspace ? join("", [title(local.global_prefix), title(var.env)]) : join("", [title(local.global_prefix), title(terraform.workspace)]))
  workspace_suffix = (local.is_default_workspace ? "" : "-${terraform.workspace}")
  resources = {
    global_prefix    = local.global_prefix,
    id_prefix        = local.id_prefix,
    name_prefix      = local.name_prefix,
    role_prefix      = local.role_prefix,
    service_prefix   = "${local.id_prefix}-${var.service}"
    env              = var.env
    env_or_workspace = local.is_default_workspace ? var.env : terraform.workspace,
    workspace_suffix = local.workspace_suffix
    db_identifier    = "${local.id_prefix}-db",
    db_name          = "${local.name_prefix}_db"
  }
}
