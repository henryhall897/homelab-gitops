# Cloudflared (Cloudflare Tunnel)

This directory manages the `cloudflared` lightweight daemon that establishes an outbound-only connection to Cloudflare's edge network, routing public traffic directly to Traefik.

---

## 🛠️ Maintenance & Chart Updates

We use the community Helm chart maintained at [charts.community-charts.org](https://charts.community-charts.org).

### How to Check for the Latest Chart Version

You can check for new releases using any of the following methods:

#### Option 1: Via Artifact Hub (Browser)
Visit [Artifact Hub - cloudflared chart](https://artifacthub.io/packages/helm/community-charts/cloudflared) to view the latest released version and changelog.

#### Option 2: Via Helm CLI
Run the following commands in your local terminal:

```bash
# Add the repository if you haven't already
helm repo add community-charts https://charts.community-charts.org

# Update local chart cache
helm repo update community-charts

# Search for the latest chart versions
helm search repo community-charts/cloudflared --versions | head -n 5
