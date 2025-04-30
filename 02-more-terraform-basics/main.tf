variable "iam_user_name_prefix" {
    type = string #any, number, tuple, object, bool, list, map, set
    default = "my_iam_user" #default value
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_user" "my_iam_users"{
    count = 2
    name = "${var.iam_user_name_prefix}_${count.index}"
}

variable "iam_user_name_prefix" {
    type = string
    default = "my_iam_user"
}