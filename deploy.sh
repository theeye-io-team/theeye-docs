
if [ -z "${THEEYE_DOCS_URL+x}" ];
then
  echo 'Env THEEYE_DOCS_URL undefined'
  exit;
fi

git clone https://github.com/theeye-io-team/theeye-web.git -b development
git clone https://github.com/theeye-io-team/theeye-supervisor.git -b development
git clone https://github.com/theeye-io-team/theeye-gateway.git -b development

cp -r theeye-web/docs/ dist/theeye-web/
cp -r theeye-supervisor/docs/ dist/theeye-supervisor/
cp -r theeye-gateway/docs/ dist/theeye-gateway
cp -r startup/ dist/

sed -i "s|theeye-web|${THEEYE_DOCS_URL}/theeye-web|" dist/_coverpage.md
sed -i "s|theeye-supervisor|${THEEYE_DOCS_URL}/theeye-supervisor|" dist/_coverpage.md

#aws s3 sync dist/ s3://theeye-docs/

