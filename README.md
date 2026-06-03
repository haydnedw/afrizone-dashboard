# Afrizone Dashboard — GitHub Pages bundle

This folder is ready to publish as a static GitHub Pages site.

Contents:
- index.html — self-contained dashboard

Quick publish with GitHub CLI:

```bash
cd /opt/data/afrizone-dashboard-pages
./publish_to_github_pages.sh
```

If `gh` is not installed system-wide in this container/session, the script will also use:

```bash
/opt/data/bin/gh
```

Your site URL should become:

```text
https://<your-github-username>.github.io/afrizone-dashboard/
```

Manual web UI route:
1. Create a new public GitHub repo called `afrizone-dashboard`
2. Upload `index.html` and `README.md`
3. In repo Settings -> Pages
4. Source: Deploy from a branch
5. Branch: `main` / root
6. Save
