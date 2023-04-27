# Deploy a containerized web application with GKE

`git clone https://github.com/GoogleCloudPlatformkubernetes-engine-samples`

`cd kubernetes-engine-samples/hello-app`

`export PROJECT_ID=projectname Chek: echo ${PROJECT_ID}`

`gcloud artifacts locations list`

`sh export REGION=EnabledRegionFromList `

gcloud artifacts repositories \
    create NameArtifactRepo \
    --repository-format=docker \
    --location=${REGION} \
    --description="Docker \
    repository"

Build image from Dockerfile in repo 

docker build -t \
    ${REGION}-docker.pkg.dev/${PROJECT_ID}/NameArtifactRepo/hello-app:v1 \
    .

`docker images`

Ensure the Artifact Registry API is enabled for the Google Cloud project you are working on:

gcloud services enable \
    artifactregistry.googleapis.com

Configure the Docker command-line tool to authenticate to Artifact Registry:

gcloud auth configure-docker \
    ${REGION}-docker.pkg.dev

Push the Docker image you just built to the repository:

docker push \
    ${REGION}-docker.pkg.dev/${PROJECT_ID}/hello-repo/hello-app:v1

Set your config for the gcloud tool:

gcloud config set project \
    ${PROJECT_ID}

gcloud config set compute/zone \
    COMPUTE_ZONE

## Create cluster:

gcloud container clusters create \
    hello-cluster

Check: `kubectl get nodes`

Verify you are connected to your GKE cluster, replacing COMPUTE_ZONE with your own zone:

gcloud container clusters \
    get-credentials hello-cluster \
    --zone COMPUTE_ZONE

kubectl create deployment \
    hello-app \
    --image=${REGION}-docker.pkg.dev/${PROJECT_ID}/hello-repo/hello-app:v1

kubectl scale deployment hello-app \
    --replicas=3

Create a HorizontalPodAutoscaler resource for your Deployment.

kubectl autoscale deployment \
    hello-app --cpu-percent=80 \
    --min=1 --max=5

Check: `kubectl get pods`

In this section, you expose the hello-app Deployment to the internet using a Service of type LoadBalancer.

Use the kubectl expose command to generate a Kubernetes Service for the hello-app deployment:

kubectl expose deployment \
    hello-app \
    --name=hello-app-service \
    --type=LoadBalancer --port 80 \
    --target-port 8080

Here, the --port flag specifies the port number configured on the Load Balancer, and the --target-port flag specifies the port number that the hello-app container is listening on.

`kubectl get service`

Copy the EXTERNAL_IP address to the clipboard

## Delite cluster

To delete the Cloud project:

```bash
gcloud projects delete ${PROJECT_ID}
```
Delete the Service: This deallocates the Cloud Load Balancer created for your Service:

kubectl delete service \
    hello-app-service

Delete the cluster:

gcloud container clusters delete \
    hello-cluster --zone \
    COMPUTE_ZONE

Delete your container images:

gcloud artifacts docker images \
    delete \
    ${REGION}-docker.pkg.dev/${PROJECT_ID}/hello-repo/hello-app:v1 \
    --delete-tags --quiet
gcloud artifacts docker images \
    delete \
    ${REGION}-docker.pkg.dev/${PROJECT_ID}/hello-repo/hello-app:v2 \
    --delete-tags --quiet