output name {
  description = "User names"
  value = [aws_iam_user.users.*.name]
}