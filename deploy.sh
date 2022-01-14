
#bash ./build.sh

aws s3 sync dist/ s3://${1}/

aws cloudfront create-invalidation --distribution-id E3K1GG932YLTA7 --paths "/*"
