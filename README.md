# my-pulp

https://pulpproject.org/pulp-operator/docs/admin/guides/install/helm/

```
helm repo add pulp-operator https://github.com/pulp/pulp-k8s-resources/raw/main/helm-charts/ --force-update
kubectl create ns pulp
kubectl config set-context --current --namespace pulp
helm -n pulp install pulp pulp-operator/pulp-operator

k apply -f my-pulp.yaml

k get secret -n pulp pulp-admin-password -o jsonpath="{.data.password}" | base64 --decode

# install Pulp python  CLI on server and client
conda activate my-tasks
pip install pulp-cli[pygments]


# Server side  ( use internal endpoint )
pulp config create --username admin --base-url https://pulp.gpu02.lysdemolab.fr --password XXXXXXXXXXXXXXXXXXXXXXXXXXXX --overwrite

# pulp file repo with autopublish
pulp  --no-verify-ssl file repository create   --name hpe  --autopublish

# https://pulpproject.org/pulp_file/docs/user/guides/upload/
pulp  --no-verify-ssl file content upload   --repository hpe   --file ./morpheus-appliance_8.0.9-1_amd64.deb  --relative-path morpheus-appliance_8.0.9-1_amd64.deb


# Client side ( use external endpoint )


```

