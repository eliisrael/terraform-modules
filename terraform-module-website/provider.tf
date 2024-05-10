

provider "aws" {
  region = var.region
  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region  = var.region
  alias   = "main"
  default_tags {
    tags = local.default_tags
  }
 }

provider "aws" {
  alias   = "cloudfront"
   region  = var.region
   default_tags {
    tags = local.default_tags
  }
}