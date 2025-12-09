## module call for drata - TCIA-5182
module "drata" {
  source = "../../modules/drata"
  providers = {
    aws = aws.dpaccount
  }
}