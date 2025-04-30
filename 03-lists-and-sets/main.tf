variable "names" {
    
    default = ["sats", "ranga", "tom", "jane"]
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_user" "my_iam_users"{
    #count = length(var.names)
    #name = var.names[count.index]
    for_each = toset(var.names) #for_each no se puede aplicar a listas, por lo qe se convierte a set, esto se hace porqe terraform, de la manera anterior, reemplaza cada elemento cuando se agrega o elimina uno, es mejor usarlo cuando se sabe qe los datos podrían cambiar, la otra opción es para cuando los datos son estáticos
    name = each.value
}
