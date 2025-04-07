resource "aws_sqs_queue" "video_queue" {
  name                       = "video-upload-queue"
  visibility_timeout_seconds = 60
  fifo_queue                 = false
}

resource "aws_sqs_queue" "notification_queue" {
  name                       = "notification-queue"
  visibility_timeout_seconds = 60
  fifo_queue                 = false
}

resource "aws_sqs_queue" "s3-object_queue" {
  name                       = "s3-object-queue"
  visibility_timeout_seconds = 60
  fifo_queue                 = false
}
