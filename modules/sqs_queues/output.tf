output "video_queue_url" {
  value = aws_sqs_queue.video_queue.url
}

output "notification_queue_url" {
  value = aws_sqs_queue.notification_queue.url
}

output "s3_object_queue_url" {
  value = aws_sqs_queue.s3-object_queue.url
}
