#/bin/bash -e

if [ -z "${THEEYE_DOCS_URL+x}" ];
then
  echo 'Env THEEYE_DOCS_URL undefined'
  exit;
fi

if [ -z "${1+y}" ];
then
  branch="development"
else
  branch="${1}"
fi
echo "using branch ${branch}"

function prepareDocs {
  echo "-----------------------------------------------------------------"
  repo=${1}

  if [ ! -d ${repo} ];
  then
    git clone https://github.com/theeye-io-team/${repo}.git -b ${branch}
  else
    (
      cd ${repo};
      echo "in $(pwd); reseting repo";
      git fetch;
      git reset HEAD --hard
    )
  fi

  cp -r ${repo}/docs/ dist/${repo}/

  sed -i "s|/${repo}|${THEEYE_DOCS_URL}/${repo}|" dist/_coverpage.md
}

# clean dist
rm -rf dist
mkdir dist
cp -r src/* dist/

prepareDocs theeye-web
prepareDocs theeye-supervisor
prepareDocs theeye-gateway
prepareDocs theeye-agent

#cp -r startup/ dist/

#aws s3 sync dist/ s3://theeye-docs/

