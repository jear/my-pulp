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
......................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................Upload complete.
Started background task /pulp/api/v3/tasks/019ac458-8653-76a9-a783-a3d4e151a51e/
.....Done.
{
  "pulp_href": "/pulp/api/v3/content/file/files/019ac458-9e7e-7c22-b68d-6bfb8db068b0/",
  "prn": "prn:file.filecontent:019ac458-9e7e-7c22-b68d-6bfb8db068b0",
  "pulp_created": "2025-11-27T08:05:33.439702Z",
  "pulp_last_updated": "2025-11-27T08:05:33.439712Z",
  "pulp_labels": {},
  "vuln_report": null,
  "artifact": "/pulp/api/v3/artifacts/019ac458-9e74-7d75-83bf-7e92e995c965/",
  "relative_path": "morpheus-appliance_8.0.9-1_amd64.deb",
  "md5": null,
  "sha1": "3570bd4faa532d56f49c82b99d70e93d2b7f7842",
  "sha224": null,
  "sha256": "7786db370de27f3121a7f59e3eb6bf0e756ea6d5727d03e4d60e8aa48c74d0f6",
  "sha384": "8e3bbb2d462424fdf8f94a96777fdb254858ad85c1f83a8fed9fd59c6c9d25e3c50cfad56904e4a35ffd0c32a310d12d",
  "sha512": "118dc8b0fea411ecf76213f04716983f5d7acf37d1a39a438eba56a48f8db41d8598fbc107b9785dc29b21f09e1c285343316e2d326fa9285bac8a0091bc4055"
}

# Create a Distribution for 'hpe'
pulp --no-verify-ssl file distribution create \
  --name hpe_latest \
  --repository file:file:hpe \
  --base-path file/hpe

# Check
pulp  --no-verify-ssl file distribution show --name  hpe_latest
{
  "pulp_href": "/pulp/api/v3/distributions/file/file/019ac45b-b6d6-7999-bc3f-12806c7147e6/",
  "prn": "prn:file.filedistribution:019ac45b-b6d6-7999-bc3f-12806c7147e6",
  "pulp_created": "2025-11-27T08:08:56.279226Z",
  "pulp_last_updated": "2025-11-27T08:08:56.279239Z",
  "base_path": "file/hpe",
  "base_url": "http://pulp-web-svc.pulp.svc.cluster.local:24880/pulp/content/file/hpe/",
  "content_guard": null,
  "no_content_change_since": null,
  "hidden": false,
  "pulp_labels": {},
  "name": "hpe_latest",
  "repository": "/pulp/api/v3/repositories/file/file/019ac44b-e57c-7fd7-b10b-29261ec34d06/",
  "publication": null,
  "checkpoint": false
}




# Client side ( use external endpoint )

# get your file
wget  .... https://pulp.83-206-89-105.nip.io/pulp/content/file/hpe/morpheus-appliance_8.0.9-1_amd64.deb

# set Pulp if necesserary

conda activate my-tasks
pip install pulp-cli[pygments]

pulp config create --username admin --base-url https://pulp.83-206-89-105.nip.io --password XXXXXXXXXXXXXXXXXXXXXXXXXXXX --overwrite




```

