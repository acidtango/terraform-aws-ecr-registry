variable "name" {
  description = "a name for the ecr registry"
  type        = string
}

variable "tag_prefix_list" {
  description = "a list of prefix for lifecycle policy"
  type        = list(string)
}

variable "tagged_count" {
  description = "number of images to keep with prefix"
  type        = number
}

variable "any_count" {
  description = "number of images to keep with any prefix"
  type        = number
}
