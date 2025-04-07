resource "aws_ecr_repository" "hackathon_repository" {
  name                 = "${var.environment}-repository"
  image_tag_mutability = "MUTABLE"
}
