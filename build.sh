#/bin/bash -e

function syncDocs {
  echo "## -----------------------------------------------------------------"
  echo '## syncing'
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
}

function compileFiles {
  echo '## ---------'
  echo '## compiling'

  repo=${1}

  if [ -d ${repo}/docs ]
  then
    cp -r ${repo}/docs/ dist/${repo}/

    sed -i "s|/${repo}|${THEEYE_DOCS_URL}/${repo}|" dist/_coverpage.md
  fi
}

if [ -z "${THEEYE_DOCS_URL+x}" ];
then
  echo 'Env THEEYE_DOCS_URL is not set'
  THEEYE_DOCS_URL='https://documentation.theeye.io'
fi

echo "using ${THEEYE_DOCS_URL}"

if [ -z "${1+y}" ];
then
  branch="development"
else
  branch="${1}"
fi
echo "using branch ${branch}"

if [ -d dist ]
then
  echo "recreating dist directory"
  rm -rf dist
  mkdir dist
fi

echo "Enter to continue..."
read

cp -r src/* dist/

syncDocs theeye-web
compileFiles theeye-web
syncDocs theeye-supervisor
compileFiles theeye-supervisor
syncDocs theeye-gateway
compileFiles theeye-gateway
syncDocs theeye-agent
compileFiles theeye-agent

syncDocs theeye-of-sauron
# copy the README from theeye-of-sauron
cp theeye-of-sauron/README.md dist
cp -r theeye-of-sauron/docs dist

