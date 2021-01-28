#
# import user and attach policies
#
data "aws_iam_user" "michael_greenly" {
  user_name = "michael.greenly"
}

#
# Need to add this to ssh config.  The "User" value is the keys aws id once created.
#
#    Host git-codecommit.*.amazonaws.com
#      User APKA5DG2FAKWL32TGTJ2
#      IdentityFile ~/.ssh/war.logic-refinery.io
#
resource "aws_iam_user_ssh_key" "mgreenly_ssh" {
  username   = data.aws_iam_user.michael_greenly.user_name
  encoding   = "SSH"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1VK1pvSuOklw7/EIIOxQZ++dCMt2ZCtOkrDylasVe3lhleHCmpxqic/JGe7p5xKIJ6IM1SwgT00AbTlotKKWRegJUyGr7ArBU0Ht+3Arej22jn/eOIBJwg4AlhTWWzLQQB/1h4h3Okoh1aOXfr7wyJmbjIlmCLtp1KKYwUQT6HiyIDK3MouspgE5S+fAO+LspRPJvw5f4J7S8BCsV7YYEHg7mtd9WC5LBkyJHgEyWZOm6yg8RJLDkoMJJh2EJE1NT7XUsdC4KwkLvgDDyUB8QbiEhU4PXREzGdoINYeO9ssOLdmwsQy0aFSOztXbpsMaj3O09x5ySTqcsrAMy1t3xDBcsQ3/Kkj9XFh6i98kQ0uQnsHER/FdI4/seO4Xpd9rEh06elhSZMTNQrayaFxdB26z4JZjIkS1j090IX/fwezawxVhzKvedyIUTLqqkx3jE7cAl0tNueaR5Dxf9isLblMm6eVzodLJMSgcY/JxdZ+gU1RdwQGaY6RnxVHXEuAE= war.logic-refinery.io"
}

resource "aws_iam_user_policy_attachment" "code_commit_power_user_and_michael_greenly" {
  user       = data.aws_iam_user.michael_greenly.user_name
  policy_arn = data.aws_iam_policy.code_commit_power_user.arn
}
