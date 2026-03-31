# Sorbr — Speed Reading & Comprehension PWA

A progressive web app for speed reading with comprehension checkpoints and notes.  
Install it directly from the browser — no app store needed.

---

## Project structure

```
sorbr/
├── index.html          # Main app (single-file)
├── manifest.json       # PWA manifest
├── sw.js               # Service worker (offline support)
├── nginx.conf          # Nginx config (used by Docker)
├── Dockerfile          # Container image
├── .do/
│   └── app.yaml        # DigitalOcean App Platform spec
└── .github/
    └── workflows/
        └── deploy.yml  # CI/CD pipeline
```

---

## Deploy to DigitalOcean (step-by-step)

### 1 — Push to GitHub

```bash
git init
git add .
git commit -m "Initial PWA"
gh repo create sorbr --public --source=. --push
# or: git remote add origin https://github.com/YOUR_USERNAME/sorbr.git && git push -u origin main
```

### 2 — Create a DigitalOcean App

1. Go to [cloud.digitalocean.com/apps](https://cloud.digitalocean.com/apps) → **Create App**
2. Connect your GitHub account and pick the `sorbr` repo, `main` branch
3. DigitalOcean will detect the `Dockerfile` automatically
4. Set **HTTP port** to `8080`
5. Choose the **Basic** plan → **$5/mo** instance
6. Click **Deploy**

Your live URL will be something like `https://sorbr-xxxxx.ondigitalocean.app`

### 3 — Enable auto-deploy via GitHub Actions (optional)

1. In DigitalOcean: **Settings → API → Generate New Token** (write scope)
2. Find your App ID: `doctl apps list`
3. In GitHub repo: **Settings → Secrets → Actions**, add:
   - `DIGITALOCEAN_ACCESS_TOKEN` — your DO token
   - `DIGITALOCEAN_APP_ID` — your app's UUID
4. Every push to `main` will now trigger a deployment automatically

### 4 — Add a custom domain (optional)

In DigitalOcean App dashboard → **Settings → Domains** → Add your domain.  
DigitalOcean provisions a free Let's Encrypt TLS cert automatically.

---

## PWA install

Once deployed, visit the URL in Chrome/Safari/Edge. You'll see an **"Add to Home Screen"** or **"Install"** prompt. The app works fully offline after the first load.

---

## Local development

```bash
# Any static server works — Python's built-in is easiest:
python3 -m http.server 8080
# Open http://localhost:8080
```

For service worker testing, use Chrome DevTools → Application → Service Workers.
