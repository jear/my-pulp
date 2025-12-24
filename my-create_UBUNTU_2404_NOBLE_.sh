REPO_NAME=UBUNTU_2404_NOBLE_UPDATES
pulp --no-verify-ssl deb remote create --name ${REPO_NAME} --url http://archive.ubuntu.com/ubuntu/ --policy on_demand --distribution noble-updates --architecture amd64  | jq -C
pulp --no-verify-ssl deb repository create --name ${REPO_NAME} --remote ${REPO_NAME} --retain-repo-versions 1  | jq -C
pulp --no-verify-ssl deb repository sync  --name ${REPO_NAME} --mirror
PULP_HREF_CURR=$(pulp --no-verify-ssl deb publication --type apt create --repository ${REPO_NAME} | jq -r .pulp_href)
pulp --no-verify-ssl deb distribution create --name ${REPO_NAME} --base-path ${REPO_NAME} --publication ${PULP_HREF_CURR}  | jq -C

REPO_NAME=UBUNTU_2404_NOBLE_BACKPORTS
pulp --no-verify-ssl deb remote create --name ${REPO_NAME} --url http://archive.ubuntu.com/ubuntu/ --policy on_demand --distribution noble-backports --architecture amd64  | jq -C
pulp --no-verify-ssl deb repository create --name ${REPO_NAME} --remote ${REPO_NAME} --retain-repo-versions 1  | jq -C
pulp --no-verify-ssl deb repository sync  --name ${REPO_NAME} --mirror
PULP_HREF_CURR=$(pulp --no-verify-ssl deb publication --type apt create --repository ${REPO_NAME} | jq -r .pulp_href)
pulp --no-verify-ssl deb distribution create --name ${REPO_NAME} --base-path ${REPO_NAME} --publication ${PULP_HREF_CURR}  | jq -C

REPO_NAME=UBUNTU_2404_NOBLE_SECURITY
pulp --no-verify-ssl deb remote create --name ${REPO_NAME} --url http://security.ubuntu.com/ubuntu/ --policy on_demand --distribution noble-security --architecture amd64  | jq -C
pulp --no-verify-ssl deb repository create --name ${REPO_NAME} --remote ${REPO_NAME} --retain-repo-versions 1  | jq -C
pulp --no-verify-ssl deb repository sync  --name ${REPO_NAME} --mirror
PULP_HREF_CURR=$(pulp --no-verify-ssl deb publication --type apt create --repository ${REPO_NAME} | jq -r .pulp_href)
pulp --no-verify-ssl deb distribution create --name ${REPO_NAME} --base-path ${REPO_NAME} --publication ${PULP_HREF_CURR}  | jq -C
