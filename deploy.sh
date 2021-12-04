
if [ -z "${THEEYE_DOCS_URL+x}" ];
then
  echo 'Env THEEYE_DOCS_URL undefined'
  exit;
fi

#git reset HEAD --hard

if [ ! -d theeye-web ];
then
  git clone https://github.com/theeye-io-team/theeye-web.git -b development
else
  (cd theeye-web; git fetch; git reset HEAD --hard)
fi

if [ ! -d theeye-supervisor ];
then
  git clone https://github.com/theeye-io-team/theeye-supervisor.git -b development
else
  (cd theeye-supervisor; git fetch; git reset HEAD --hard)
fi

if [ ! -d theeye-gateway ];
then
  git clone https://github.com/theeye-io-team/theeye-gateway.git -b development
else
  (cd theeye-gateway; git fetch; git reset HEAD --hard)
fi

rm -rf dist
mkdir dist
cp -r src/* dist/

cp -r theeye-web/docs/ dist/theeye-web/
cp -r theeye-supervisor/docs/ dist/theeye-supervisor/
cp -r theeye-gateway/docs/ dist/theeye-gateway
#cp -r startup/ dist/

sed -i "s|/theeye-web|${THEEYE_DOCS_URL}/theeye-web|" dist/_coverpage.md
sed -i "s|/theeye-supervisor|${THEEYE_DOCS_URL}/theeye-supervisor|" dist/_coverpage.md
#sed -i "s|theeye-gateway|${THEEYE_DOCS_URL}/theeye-gateway|" dist/_coverpage.md

#aws s3 sync dist/ s3://theeye-docs/

