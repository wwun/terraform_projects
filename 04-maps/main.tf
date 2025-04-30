variable "users" {
    
    default = {
        ravs: "Netherlands",    #map of maps    ravs: {country: "Netherlands"},
        tom: "US",              #               tom: {country: "US"},
        jane: "India"           #               jane: {country: "India"}
    }
}

variable "users_maps_of_maps" {
    
    default = {
        #map of maps
        ravs: {country: "Netherlands", department: "ABC"},
        tom: {country: "US", department: "DEF"},
        jane: {country: "India", department: "XYZ"}
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_user" "my_iam_users"{
    #for_each = var.users   #for users
    for_each = var.users_maps_of_maps
    name = each.key
    tags = {
        #country: each.value    #for users
        country: each.value.country
        department: each.value.department
    }
}
