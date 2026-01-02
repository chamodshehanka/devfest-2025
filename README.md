# Basic Agent

This is a basic agent that can used to test KAgent BYO agent with ADK.

1. Build the agent image

Create .env
```
GOOGLE_CLOUD_PROJECT="$(gcloud config get-value project)"
GOOGLE_CLOUD_PROJECT_NUMBER="$(gcloud projects describe $(gcloud config get-value project) --format='value(projectNumber)')"
GOOGLE_CLOUD_LOCATION="us-central1"
MODEL="gemini-2.5-flash"
GOOGLE_API_KEY=""
```

Create a Google Artifact Registry repository to push the image
```shell
gcloud artifacts repositories create devfest-adk \
  --repository-format=docker \
  --location=us-central1 \
  --description="DevFest ADK repository"
```

Push the image to Google Artifact Registry

```bash
gcloud builds submit \
  --tag $GOOGLE_CLOUD_LOCATION-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/devfest-adk/adk-agent:latest \
  --project=$GOOGLE_CLOUD_PROJECT \
  .
```

```shell
helm install kagent-crds oci://ghcr.io/kagent-dev/kagent/helm/kagent-crds \
    --namespace kagent \
    --create-namespace
```
```shell
helm install kagent oci://ghcr.io/kagent-dev/kagent/helm/kagent \
    --namespace kagent \
    --set providers.default=gemini \
    --set providers.gemini.apiKey=$GOOGLE_API_KEY
```
2. Create a secret with the google api key

```bash
kubectl create secret generic kagent-google --from-literal=GOOGLE_API_KEY=$GOOGLE_API_KEY   --dry-run=client -oyaml | k apply -f -
```

3. Deploy the agent

```bash
kubectl apply -f agent.yaml
```

```shell
kubectl port-forward -n kagent service/kagent-ui 8082:8080
```