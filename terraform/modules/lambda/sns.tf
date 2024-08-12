# module "notification_topic" {
#   source = "git::ssh://git@gitlab.com/securetrading-gl/st-server-project/project-infrastructure.git//terraform/modules/sns/topic?ref=57.0.0"
#
#   environment = var.environment
#   name        = "sjst-notifications"
#
#   documentation = {
#     description = "All-in-one ST Java Service Template Infrastructure Alarms/Notifications Topic"
#     categories = [
#       "monitoring",
#       "infrastructure",
#       "alarms",
#       "notifications",
#     ]
#   }
#
#   # Since this is **the** infra notification topic its alarms should also be sent through it.
#   # We should however use it for all other topics as the alarm topic.
#   alarms_topic_arn = null
#
#   tags = var.tags
# }
