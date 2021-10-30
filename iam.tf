##################################################################
#Creation of Iam instance role
##################################################################
#In this case you can create the role with a json file or invoke an existing role in aws through the data.tf. both cases are equally valid and adapt to the use case.

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.myrole.name
}

resource "aws_iam_role" "myrole" {
  name               =  "myrole"
  assume_role_policy = "${file("dynamodbrole.json")}"
}