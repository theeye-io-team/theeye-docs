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
      git checkout ${branch}
      git reset origin/${branch} --hard
    )
  fi

  if [ -d ${repo}/docs ]
  then
    cp -r ${repo}/docs/ dist/${repo}/

    sed -i "s|/${repo}|${THEEYE_DOCS_URL}/${repo}|" dist/_coverpage.md
  fi
}

# clean dist
rm -rf dist
mkdir dist
cp -r src/* dist/

prepareDocs theeye-of-sauron
prepareDocs theeye-web
prepareDocs theeye-supervisor
prepareDocs theeye-gateway
prepareDocs theeye-agent

# copy the README from theeye-of-sauron
cp theeye-of-sauron/README.md dist
