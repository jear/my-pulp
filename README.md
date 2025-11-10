# my-pulp

https://pulpproject.org/pulp-operator/docs/admin/guides/install/helm/

```
helm repo add pulp-operator https://github.com/pulp/pulp-k8s-resources/raw/main/helm-charts/ --force-update
kubectl create ns pulp
kubectl config set-context --current --namespace pulp
helm -n pulp install pulp pulp-operator/pulp-operator

k apply -f- <<EOF
apiVersion: repo-manager.pulpproject.org/v1
kind: Pulp
metadata:
  name: pulp
  namespace: pulp
spec:
  allowed_content_checksums: ["sha1", "sha256", "sha384", "sha512"]
  api:
    replicas: 1
  content:
    replicas: 1
  worker:
    replicas: 1
  cache:
    enabled: true
    redis_storage_class: rook-ceph-block
  web:
    replicas: 1

  database:
    enabled: true
    postgres_storage_class: rook-ceph-block

#  file_storage_storage_class: my-sc-for-pulpcore
  file_storage_storage_class: rook-cephfs
  file_storage_access_mode: "ReadWriteMany"
  file_storage_size: "50Gi"
 
EOF
```

