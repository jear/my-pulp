# my-pulp install in k8s

https://pulpproject.org/pulp-operator/docs/admin/guides/install/helm/

```
helm repo add pulp-operator https://github.com/pulp/pulp-k8s-resources/raw/main/helm-charts/ --force-update
kubectl create ns pulp
kubectl config set-context --current --namespace pulp
helm -n pulp install pulp pulp-operator/pulp-operator

k apply -f my-pulp.yaml

k get secret -n pulp pulp-admin-password -o jsonpath="{.data.password}" | base64 --decode
```

# my-pulp CLI install 
```
# install Pulp python  CLI on server and client
conda activate my-tasks
pip install pulp-cli[pygments]


# Server side  ( use internal endpoint )
pulp config create --username admin --base-url https://pulp.gpu02.lysdemolab.fr --password XXXXXXXXXXXXXXXXXXXXXXXXXXXX --overwrite
```

# Pulp File Repo
```
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
```

# Client side : use external endpoint 
```
# get your file
curl -o morpheus-appliance_8.0.9-1_amd64.deb  https://pulp.83-206-89-105.nip.io/pulp/content/file/hpe/morpheus-appliance_8.0.9-1_amd64.deb

# set Pulp if necesserary

conda activate my-tasks
pip install pulp-cli[pygments]

pulp config create --username admin --base-url https://pulp.83-206-89-105.nip.io --password XXXXXXXXXXXXXXXXXXXXXXXXXXXX --overwrite

```

# my-pulp Ubuntu 24.04
- https://pulpproject.org/pulp_deb/docs/user/guides/sync/
- https://pulpproject.org/pulp_deb/docs/user/guides/sync/#important-apt-remote-flags
- https://discourse.pulpproject.org/t/ubuntu-supported/1173/6
```
# Create deb remote
pulp --no-verify-ssl deb remote create --name UBUNTU_2404_NOBLE --url http://archive.ubuntu.com/ubuntu/ --policy on_demand --distribution noble --architecture amd64  | jq -C
()
{
  "pulp_href": "/pulp/api/v3/remotes/deb/apt/019ac607-173e-7634-b0d9-588c4c955e43/",
  "prn": "prn:deb.aptremote:019ac607-173e-7634-b0d9-588c4c955e43",
  "pulp_created": "2025-11-27T15:55:44.831738Z",
  "pulp_last_updated": "2025-11-27T15:55:44.831753Z",
  "name": "UBUNTU_2404_NOBLE",
  "url": "http://archive.ubuntu.com/ubuntu/",
  "ca_cert": null,
  "client_cert": null,
  "tls_validation": true,
  "proxy_url": null,
  "pulp_labels": {},
  "download_concurrency": null,
  "max_retries": null,
  "policy": "on_demand",
  "total_timeout": null,
  "connect_timeout": null,
  "sock_connect_timeout": null,
  "sock_read_timeout": null,
  "headers": null,
  "rate_limit": null,
  "hidden_fields": [
    {
      "name": "client_key",
      "is_set": false
    },
    {
      "name": "proxy_username",
      "is_set": false
    },
    {
      "name": "proxy_password",
      "is_set": false
    },
    {
      "name": "username",
      "is_set": false
    },
    {
      "name": "password",
      "is_set": false
    }
  ],
  "distributions": "noble",
  "components": null,
  "architectures": "amd64",
  "sync_sources": false,
  "sync_udebs": false,
  "sync_installer": false,
  "gpgkey": null,
  "ignore_missing_package_indices": false
}

# create deb repo
pulp --no-verify-ssl deb repository create --name UBUNTU_2404_NOBLE --remote UBUNTU_2404_NOBLE --retain-repo-versions 3  | jq -C
{
  "pulp_href": "/pulp/api/v3/repositories/deb/apt/019ac608-0c06-7b63-bc5e-979c7996dd29/",
  "prn": "prn:deb.aptrepository:019ac608-0c06-7b63-bc5e-979c7996dd29",
  "pulp_created": "2025-11-27T15:56:47.496274Z",
  "pulp_last_updated": "2025-11-27T15:56:47.509045Z",
  "versions_href": "/pulp/api/v3/repositories/deb/apt/019ac608-0c06-7b63-bc5e-979c7996dd29/versions/",
  "pulp_labels": {},
  "latest_version_href": "/pulp/api/v3/repositories/deb/apt/019ac608-0c06-7b63-bc5e-979c7996dd29/versions/0/",
  "name": "UBUNTU_2404_NOBLE",
  "description": null,
  "retain_repo_versions": 3,
  "remote": "/pulp/api/v3/remotes/deb/apt/019ac607-173e-7634-b0d9-588c4c955e43/",
  "autopublish": false,
  "publish_upstream_release_fields": true,
  "signing_service": null,
  "signing_service_release_overrides": {}
}

# Sync/Mirror
pulp --no-verify-ssl deb repository sync  --name UBUNTU_2404_NOBLE --mirror
Started background task /pulp/api/v3/tasks/019ac62c-9393-7b02-96c1-f849c4ae85fe/
...............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................Done.

# if you Ctrl-C during the sync, it sends tasks to background
pulp --no-verify-ssl deb repository sync  --name UBUNTU_2404_NOBLE --mirror
Started background task /pulp/api/v3/tasks/019ac64c-91a7-789c-b387-0d80172a3bf9/
..................................Task /pulp/api/v3/tasks/019ac64c-91a7-789c-b387-0d80172a3bf9/ sent to background.

# deb remote update
pulp --no-verify-ssl deb remote update --name UBUNTU_2404_NOBLE \
  --distribution noble \
  --distribution noble-security \
  --distribution noble-backports \
  --distribution noble-updates


# create publication
#pulp --no-verify-ssl deb publication --type verbatim create --repository UBUNTU_2404_NOBLE
pulp --no-verify-ssl deb publication --type apt create --repository UBUNTU_2404_NOBLE
Started background task /pulp/api/v3/tasks/019ac614-18e5-7c7e-a833-d6be34acdd79/
Done.
{
  "pulp_href": "/pulp/api/v3/publications/deb/apt/019ac614-1943-78c4-8422-c0639f601d65/",
  "prn": "prn:deb.aptpublication:019ac614-1943-78c4-8422-c0639f601d65",
  "pulp_created": "2025-11-27T16:09:57.317289Z",
  "pulp_last_updated": "2025-11-27T16:09:57.338235Z",
  "repository_version": "/pulp/api/v3/repositories/deb/apt/019ac608-0c06-7b63-bc5e-979c7996dd29/versions/0/",
  "repository": "/pulp/api/v3/repositories/deb/apt/019ac608-0c06-7b63-bc5e-979c7996dd29/",
  "simple": false,
  "structured": true,
  "checkpoint": false,
  "signing_service": null
}

# Create distribution
pulp  --no-verify-ssl deb distribution create --name UBUNTU_2404_NOBLE --base-path UBUNTU_2404_NOBLE --publication /pulp/api/v3/publications/deb/apt/019ac614-1943-78c4-8422-c0639f601d65/

# update publication
pulp --no-verify-ssl deb distribution update --name UBUNTU_2404_NOBLE  --publication  /pulp/api/v3/publications/deb/verbatim/019ac614-1943-78c4-8422-c0639f601d65/



```

# my-pulp Ubuntu 22.04
https://discourse.pulpproject.org/t/ubuntu-supported/1173/2
```
pulp deb remote create --name UBUNTU_2204_JAMMY --url http://archive.ubuntu.com/ubuntu/ --policy on_demand --distribution jammy --architecture amd64  | jq -C
pulp deb repository create --name UBUNTU_2204_JAMMY --remote UBUNTU_2204_JAMMY --retain-repo-versions 3  | jq -C
pulp deb repository sync  --name UBUNTU_2204_JAMMY --mirror
pulp deb publication --type verbatim create --repository UBUNTU_2204_JAMMY
pulp deb distribution create --name UBUNTU_2204_JAMMY_TEST --base-path UBUNTU_2204_JAMMY_TEST --publication /pulp/api/v3/publications/deb/verbatim/018e80b2-b33e-7b3e-b9e4-7195736c3c08/

pulp deb remote update --name UBUNTU_2204_JAMMY \
  --distribution jammy \
  --distribution jammy-security \
  --distribution jammy-backports \
  --distribution jammy-updates
```


