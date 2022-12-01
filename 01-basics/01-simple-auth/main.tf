provider "aws" {
  region     = "us-east-2"
  access_key = "ASIAT3MEQDOEZPW6XZZR"
  secret_key = "4APG0CzGvjvPP1y5Lp48qZ30GxgwmkIr2wuHJjbn"
  token      = "IQoJb3JpZ2luX2VjEHwaCXVzLWVhc3QtMSJIMEYCIQCQexoWktn55aosXPKzkSGzfDJe1F+6TtXfmN54r0++nAIhAIu2dqYWR+YJ5jmJRSD1uMSqnbpjGBwcMq9R8ZU8z+VBKqMDCJX//////////wEQABoMMjY0OTU1MjM5MzA1Igxg3lLiIt5tw9SkgOkq9wJZd6kgrFE/u0Z8YAprZfDjCvPWcBe/1MGeSePiVIalPIbfcnEGLE/D8KqnucUY5kJt+COtKDN/Zfu8XrwVQtufohAED+vhLgwCWku3PVVQaOW5wuiKnx5jx8av/zpGkH4iZZutCHKngGIRyhlZGgn/+WYqcgemchqZj5pgUmWZChAIoNrVBA393MDXwwqGhUFtnKdDiNKq2Brdkj01AFWF+sZR9obpSz3LVt7i1MrSieYK/5OvRCGFNko4Re7Pyle8ASc3KwdsRNdBHj9rI+TTaWF0OMqm3LUhsJ0ptyCiKCjWASQf6asMa0HIopciQ8Jea2z+TiU6kGFrH/BLft2n4JO4FClaaVeZoWai6Nh4BGzxCLhnN2dQLZ2GcVagX0Y+Vpx7sHcsOs7koikr0hhC+0ZdfBN+STVEvUhHsRE+VGVLj4U3/muDQnp4Q4S18csQMgqf6vmPLvv1TEvPPujLjw3Bo25UU1Ld/5wopXP7PSFTkmfnEBcwo4GknAY6pQHTsmjR4m/WOABu4+TmlV3h+mu6Ka2BbBysFTBYxKR4rBukkAmzVgP+d+B1JwVFz1NIB2FuASbboerIrFzvRgA7Jx0duFDNjMz4XWBnD+Cu6uBP+hx97yrgSeMvBz4jyghv4kGBZhFLLQaFyrOHVvzwHMhQr5mgllNGvPreGSuUQNFOZw+BWdjrjufhO7WTE61hheBI7OhEk2PCIgQwjSvpnayLktw="
}

resource "aws_s3_bucket" "b" {
  bucket = "jag-tf-test-bucket"
  #acl = "private" #this is deprecated and thus need to use another resource

  tags = {
    Name        = "Jag Test bucket"
    Environment = "JagTest"
    CreatedBy   = "Jag"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}
