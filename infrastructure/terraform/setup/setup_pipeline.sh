#!/bin/bash

# Load configuration from config.env
if [[ -f .env ]]; then
  source .env
else
  echo "Error: config.env file not found. Please create one with the required variables."
  exit 1
fi

# Check required variables
REQUIRED_VARS=("PROJECT_ID" "PROJECT_NUMBER" "STATE_BUCKET" "POOL_NAME")
for var in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!var}" ]]; then
    echo "Error: $var is not set in config.env"
    exit 1
  fi
done

# Step 1: Create a GCS bucket for Terraform state in US East
echo "Creating GCS bucket for Terraform state in $REGION..."
gcloud storage buckets create gs://$STATE_BUCKET \
  --project=$PROJECT_ID \
  --default-storage-class=STANDARD \
  --location=$REGION \
  --uniform-bucket-level-access

# Step 2: Create Workload Identity Pool
echo "Creating Workload Identity Pool ($POOL_NAME)..."
gcloud iam workload-identity-pools create "$POOL_NAME" \
  --project=$PROJECT_ID \
  --location="global" \
  --description="GitHub Workload Identity Pool" \
  --display-name="GitHub Pool"

# Step 3: Create OIDC Provider
echo "Creating OIDC Provider..."
gcloud iam workload-identity-pools providers create-oidc "github" \
  --project=$PROJECT_ID \
  --location="global" \
  --workload-identity-pool="$POOL_NAME" \
  --display-name="GitHub Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.workflow_ref=assertion.job_workflow_ref,attribute.event_name=assertion.event_name" \
  --attribute-condition="assertion.repository_owner == '$GITHUB_REPO_OWNER'" \
  --issuer-uri="https://token.actions.githubusercontent.com"

# Step 4: Create Terraform Planner and Applier service accounts
echo "Creating Terraform Planner and Applier service accounts..."
gcloud iam service-accounts create tf-plan \
  --project=$PROJECT_ID \
  --description="SA for Terraform Plan" \
  --display-name="Terraform Planner"

gcloud iam service-accounts create tf-apply \
  --project=$PROJECT_ID \
  --description="SA for Terraform Apply" \
  --display-name="Terraform Applier"

# Step 5: Grant bucket permissions
echo "Granting permissions to GCS bucket..."
gcloud storage buckets add-iam-policy-binding gs://$STATE_BUCKET \
  --member="serviceAccount:tf-plan@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"

gcloud storage buckets add-iam-policy-binding gs://$STATE_BUCKET \
  --member="serviceAccount:tf-apply@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"

# Step 6: Grant project-level permissions
echo "Granting project-level permissions to service accounts..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:tf-apply@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/editor"

# Step 7: Bind service accounts to Workload Identity Pool
echo "Binding service accounts to Workload Identity Pool..."
gcloud iam service-accounts add-iam-policy-binding "tf-plan@$PROJECT_ID.iam.gserviceaccount.com" \
  --project=$PROJECT_ID \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$POOL_NAME/attribute.event_name/pull_request"

gcloud iam service-accounts add-iam-policy-binding "tf-apply@$PROJECT_ID.iam.gserviceaccount.com" \
  --project=$PROJECT_ID \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$POOL_NAME/attribute.repository/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME"

echo "Setup completed successfully!"