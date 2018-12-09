variable "KEY" {}

variable "SECRET" {}

variable "key"{
    default = "demo"
    type	= "string"
}

variable "REGION"{}

variable "ami"{
	default="ami-0cde3dd752cb2be89"
	type="string"
}

variable "privateip1"{
  default="172.31.32.5"
  type="string"
}

variable "privateip2"{
  default="172.31.32.6"
  type="string"
}

variable "privateip3"{
  default="172.31.32.7"
  type="string"
}

variable "subnet"{
	default="subnet-524a860e"
	type="string"

}
