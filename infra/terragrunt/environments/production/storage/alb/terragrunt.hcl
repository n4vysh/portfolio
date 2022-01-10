include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_s3_bucket" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-s3-bucket.hcl"
}

inputs = {
  attach_elb_log_delivery_policy = true
  attach_lb_log_delivery_policy  = true

  acl = "log-delivery-write"

  lifecycle_rule = [
    {
      id      = "expiration"
      enabled = true
      expiration = {
        days = 1
      }
    }
  ]
}
