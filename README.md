# my-pulp

https://pulpproject.org/pulp-operator/docs/admin/guides/install/helm/

```
helm repo add pulp-operator https://github.com/pulp/pulp-k8s-resources/raw/main/helm-charts/ --force-update
kubectl create ns pulp
kubectl config set-context --current --namespace pulp
helm -n pulp install pulp pulp-operator/pulp-operator

k apply -f my-pulp.yaml


```

