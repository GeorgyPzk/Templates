# Script for PS to deploy bank of anthos k8s

$PROJECT_ID="polska-gavnyashka"
$REGION="europe-central2"

gcloud services enable container --project ${PROJECT_ID}

git clone https://github.com/GoogleCloudPlatform/bank-of-anthos.git

cd bank-of-anthos/

gcloud services enable container.googleapis.com monitoring.googleapis.com --project ${PROJECT_ID}

gcloud container clusters create-auto bank-of-anthos  --project=${PROJECT_ID} --region=${REGION}

gcloud container clusters get-credentials bank-of-anthos --project=${PROJECT_ID} --region=${REGION}

kubectl apply -f ./extras/jwt/jwt-secret.yaml
kubectl apply -f ./kubernetes-manifests

kubectl get pods