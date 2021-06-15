Changes made to run this "now" and on Mac minikube:
- Change helm repo from
  https://kubernetes-charts.storage.googleapis.com/
  to https://charts.helm.sh/stable

- minikube: run "minikube tunnel" to be able to access Ingress

- kind:

- kubeseal
  - $ brew install kubeseal
  - Change helm repo for sealed-secrets
    - also need to run "k proxy" to be able to run
      "kubeseal --fetch-cert..."
