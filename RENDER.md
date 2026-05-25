# Render Deployment

This repo is prepared as a single Laravel + Vue app. Render builds the Docker image, runs Vite during the image build, and serves Laravel from `public/`.

## Required Environment Variables

Set these in Render after creating the web service:

```env
APP_KEY=base64:...
APP_URL=https://your-service.onrender.com
FRONTEND_URL=https://your-service.onrender.com
```

Generate `APP_KEY` locally or in any PHP environment:

```bash
php artisan key:generate --show
```

The included `render.yaml` also creates a free Render Postgres database and wires `DATABASE_URL` automatically.
It also runs migrations and seeders on startup for demo data.

Default seeded demo account:

```text
Email: admin@ticktrack.com
Password: password
```

Change the seeded credentials before using this as a public production app.

## Notes

- Free Render Postgres expires after 30 days. Use it for demos only.
- Free Render web services can sleep when inactive.
- Uploaded attachments are stored on the container filesystem. For production, use S3-compatible storage or another persistent object storage provider.
