#!/bin/bash

# Load variables from .env file
if [[ -f .env ]]; then
  source .env
else
  echo ".env file not found. Please create one with the required variables."
  exit 1
fi

# Validate required variables
REQUIRED_VARS=("PROJECT_ID" "GITHUB_REPO_OWNER" "GITHUB_REPO_NAME" "POOL_NAME" "PLANNER_SA" "APPLIER_SA")
for var in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!var}" ]]; then
    echo "Error: $var is not set in the .env file."
    exit 1
  fi
done

# Enable required APIs
echo "Enabling required APIs..."
gcloud services enable iam.googleapis.com cloudresourcemanager.googleapis.com

# Create Planner Service Account
echo "Creating Planner Service Account ($PLANNER_SA)..."
gcloud iam service-accounts create "$PLANNER_SA" \
  --description="Service account for Terraform plan" \
  --display-name="Terraform Planner"

# Create Applier Service Account
echo "Creating Applier Service Account ($APPLIER_SA)..."
gcloud iam service-accounts create "$APPLIER_SA" \
  --description="Service account for Terraform apply" \
  --display-name="Terraform Applier"

# Grant roles to Planner Service Account
echo "Granting roles to Planner Service Account..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${PLANNER_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/viewer"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${PLANNER_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/storage.objectViewer"

# Grant roles to Applier Service Account
echo "Granting roles to Applier Service Account..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${APPLIER_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/editor"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${APPLIER_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"

# Create Workload Identity Pool
echo "Creating Workload Identity Pool ($POOL_NAME)..."
gcloud iam workload-identity-pools create "$POOL_NAME" \
  --project="$PROJECT_ID" \
  --location="global" \
  --display-name="Terraform Workload Identity Pool"

# Create OIDC Provider for GitHub Actions
echo "Creating OIDC Provider for GitHub Actions..."
gcloud iam workload-identity-pools providers create-oidc github-provider \
  --project="$PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="$POOL_NAME" \
  --display-name="GitHub Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.workflow_ref=assertion.job_workflow_ref,attribute.event_name=assertion.event_name" \
  --issuer-uri="https://token.actions.githubusercontent.com"

# Bind Planner Service Account to Workload Identity
echo "Binding Planner Service Account to Workload Identity..."
gcloud iam service-accounts add-iam-policy-binding "${PLANNER_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_ID}/locations/global/workloadIdentityPools/${POOL_NAME}/attribute.repository/${GITHUB_REPO_OWNER}/${GITHUB_REPO_NAME}"

# Bind Applier Service Account to Workload Identity
echo "Binding Applier Service Account to Workload Identity..."
gcloud iam service-accounts add-iam-policy-binding "${APPLIER_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_ID}/locations/global/workloadIdentityPools/${POOL_NAME}/attribute.repository/${GITHUB_REPO_OWNER}/${GITHUB_REPO_NAME}"

echo "Setup completed successfully!"