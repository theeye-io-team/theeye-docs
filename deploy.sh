git clone https://github.com/theeye-io-team/theeye-web.git
git clone https://github.com/theeye-io-team/theeye-supervisor.git
git clone https://github.com/theeye-io-team/theeye-gateway.git

cp -r theeye-web/docs/ dist/theeye-web/
cp -r theeye-supervisor/docs/ dist/theeye-supervisor/
cp -r theeye-gateway/docs/ dist/theeye-gateway
cp -r startup/ dist/

#aws s3 sync dist/ s3://theeye-docs/

