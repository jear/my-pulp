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
  database:
    postgres_storage_class: default
  web:
    replicas: 1

  file_storage_access_mode: "ReadWriteMany"
  file_storage_size: "50Gi"
  file_storage_storage_class: default
EOF
```

