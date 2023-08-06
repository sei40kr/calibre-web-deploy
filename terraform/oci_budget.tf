resource "oci_budget_budget" "calibre_web" {
  amount         = var.budget_amount
  compartment_id = oci_identity_compartment.calibre_web.compartment_id
  reset_period   = "MONTHLY"

  description  = "Budget for Calibre-Web"
  display_name = "calibre-web"
  targets      = [oci_identity_compartment.calibre_web.id]
}

resource "oci_budget_alert_rule" "calibre_web" {
  budget_id      = oci_budget_budget.calibre_web.id
  threshold      = 80
  threshold_type = "PERCENTAGE"
  type           = "FORECAST"

  description  = "Budget for Calibre-Web has exceeded 80% of the budgeted amount."
  display_name = "calibre-web"
  message      = "Budget for Calibre-Web has exceeded 80% of the budgeted amount."
}
