variable "record_domain" { 
    description = "The domain to create the record in"
}

variable "record_name" { 
    type = string
    description = "The name of the record"
}

variable "record_data" {
    type = string
    description = "The data of the record"
}

variable "record_type" {
    type = string
    description = "The type of the record"
}