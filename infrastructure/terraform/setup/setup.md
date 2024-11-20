Ensure gcloud CLI is enabled..


Fill in respective variables:
```
echo "PROJECT_ID=my-project-id" > .env
echo "GITHUB_REPO_OWNER=my-org" >> .env
echo "GITHUB_REPO_NAME=my-repo" >> .env
echo "POOL_NAME=terraform-pool" >> .env
echo "PLANNER_SA=terraform-planner" >> .env
echo "APPLIER_SA=terraform-applier" >> .env
```

```
chmod +x setup_pipeline.sh
```