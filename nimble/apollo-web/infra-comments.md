• Right — those shouldn’t be in config. Alarm ARNs for target tracking policies are computed by AWS and will change over time. Don’t hardcode them; use refresh-only apply (or add ignore_changes =
  [alarm_arns]) if they keep showing drift.

• For the primary autoscaling policy, no—you shouldn’t gate it with enable_blue_green_deployment. You want primary scaling in all environments. Only the secondary policies should be conditional.

• Because you always have the primary ECS service running, regardless of blue‑green. It needs autoscaling in every environment. The secondary service only exists when blue‑green is enabled, so its
  autoscaling policies should be conditional.
  