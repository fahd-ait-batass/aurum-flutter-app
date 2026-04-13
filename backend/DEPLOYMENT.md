# Backend Deployment

The cleanest hosting path for this backend is Railway.

Why Railway fits this project:
- It supports Dockerfiles directly.
- It supports persistent volumes, which matches this backend's JSON file persistence.
- It provides generated public domains quickly.
- It supports isolated environments and service variables.

Official references:
- Dockerfiles: https://docs.railway.com/deploy/dockerfiles
- Volumes: https://docs.railway.com/guides/volumes
- Variables: https://docs.railway.com/variables
- Domains: https://docs.railway.com/networking/domains/working-with-domains
- Monorepo root directory: https://docs.railway.com/guides/deploying-a-monorepo
- Config as code: https://docs.railway.com/config-as-code

## Railway Deployment Steps

1. Create a new Railway project.
2. Add a new service and connect this repository.
3. In the backend service settings, set the root directory to `/backend`.
4. In the backend service settings, set the config-as-code file path to `/backend/railway.json`.
5. Keep the existing `Dockerfile`; Railway will use it from the backend root.
6. Add a volume and mount it to `/app/data`.
7. In service variables, set:
   - `AURUM_BACKEND_ENV=production`
   - `AURUM_ALLOWED_ORIGINS=https://your-frontend-domain.example`
   - `AURUM_PUBLIC_BASE_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}`
8. Optionally set:
   - `AURUM_BACKEND_DATA_DIR=/app/data`
   - This is optional on Railway because the app now understands `RAILWAY_VOLUME_MOUNT_PATH`.
9. Generate a Railway public domain in the service Networking settings.
10. Deploy the service.
11. After deploy, your backend base URL will be either:
   - `https://your-service.up.railway.app`
   - or your custom domain, for example `https://api.example.com`

## Runtime Variables

Required:
- `AURUM_BACKEND_ENV`
- `AURUM_ALLOWED_ORIGINS`

Usually provided by Railway automatically:
- `PORT`
- `RAILWAY_PUBLIC_DOMAIN`
- `RAILWAY_VOLUME_MOUNT_PATH`

Optional overrides:
- `AURUM_PUBLIC_BASE_URL`
- `AURUM_BACKEND_HOST`
- `AURUM_BACKEND_DATA_DIR`

## Config As Code

The backend now includes `/backend/railway.json` with:
- `DOCKERFILE` builder
- `healthcheckPath=/api/health`
- `healthcheckTimeout=120`
- `restartPolicyType=ON_FAILURE`
- `restartPolicyMaxRetries=10`
- `requiredMountPath=/app/data`
- `drainingSeconds=30`

This keeps the deployment behavior close to the repo and reduces manual dashboard drift.

## App Connection

For the Flutter app, use:
- `AURUM_BACKEND_TARGET=hosted`
- `AURUM_REMOTE_PROVIDER=rest`
- `AURUM_REMOTE_BASE_URL=https://your-service.up.railway.app/api`

Or with a custom domain:
- `AURUM_REMOTE_BASE_URL=https://api.example.com/api`

You can pass these via `--dart-define` or use the hosted launch config in `flutter_app/.vscode/launch.json`.
