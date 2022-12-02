# google_secret_manager_secret.secret-basic:
resource "google_secret_manager_secret" "gcp-secret" {
    labels      = {}
    project     = var.project_id
    secret_id   = var.secret_id

    replication {
        automatic = true
    }

    timeouts {}
}

# google_secret_manager_secret_version.secret-version-basic:
resource "google_secret_manager_secret_version" "gcp-secret-version" {
    enabled     = true
    secret      = google_secret_manager_secret.gcp-secret.id
    secret_data = var.secret_data
    timeouts {}
}


# google_pubsub_topic.example:
resource "google_pubsub_topic" "gcp-topic" {
    labels  = {}
    name    = var.topic_name
    project = var.project_id

    timeouts {}
}

# google_pubsub_subscription.example:
resource "google_pubsub_subscription" "example" {
    ack_deadline_seconds         = 60
    enable_exactly_once_delivery = true
    enable_message_ordering      = false
    labels                       = {}
    message_retention_duration   = "604800s"
    name                         = var.subscription_name
    project                      = var.project_id
    retain_acked_messages        = false
    topic                        = google_pubsub_topic.gcp-topic.id

    expiration_policy {
        ttl = "2678400s"
    }

    push_config {
        attributes    = {}
        push_endpoint = var.push_url

        oidc_token {
            service_account_email = var.service_account_email
        }
    }

    timeouts {}
}