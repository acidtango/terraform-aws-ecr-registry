// ECR configuration

resource "aws_ecr_repository" "registry" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


// lifecycle policies (delete unused images)

resource "aws_ecr_lifecycle_policy" "lifecycle-policy" {
  repository = aws_ecr_repository.registry.name

  policy = jsonencode(
    {
      rules = [
        {
          action = {
            type = "expire"
          }
          description  = "Expire untagged images older than 1 days"
          rulePriority = 1
          selection = {
            countNumber = 1
            countType   = "sinceImagePushed"
            countUnit   = "days"
            tagStatus   = "untagged"
          }
        },
        {
          action = {
            type = "expire"
          }
          description  = "Keep last ${var.tagged_count} staging images"
          rulePriority = 2
          selection = {
            countNumber   = var.tagged_count
            countType     = "imageCountMoreThan"
            tagPrefixList = var.tag_prefix_list
            tagStatus     = "tagged"
          }
        },
        {
          action = {
            type = "expire"
          }
          description  = "keep last ${var.any_count} tags including production releases to avoid infrastructure costs"
          rulePriority = 3
          selection = {
            countNumber = var.any_count
            countType   = "imageCountMoreThan"
            tagStatus   = "any"
          }
        },
      ]
    }
  )
}
