# update submodule
git submodule update --init
# set tag for boost submodules
DEFAULT_TAG="boost-1.70.0"
# update
git config -f .gitmodules --get-regexp '^submodule\..*\.url$' |
    while read -r KEY MODULE_PATH; do
        NAME="$(echo "${KEY}" | sed 's/^submodule\.\(.*\)\.url$/\1/')"
        if [[ $NAME =~ "boost" ]]; then
          pushd "${NAME}"
          git checkout -b new_branch_boost $DEFAULT_TAG                   
          popd
        fi
    done