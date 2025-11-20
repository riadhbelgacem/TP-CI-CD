#!/bin/bash
# Restart Monitoring Stack to Apply Configuration Changes

echo "🔄 Restarting Prometheus and Application Pods..."

# Reapply Prometheus configuration
echo "📊 Updating Prometheus configuration..."
kubectl apply -f prometheus-deployment.yml -n jenkins

# Restart Prometheus to reload config
echo "🔄 Restarting Prometheus pod..."
kubectl rollout restart deployment/prometheus-deployment -n jenkins

# Reapply application deployment (to ensure annotations are applied)
echo "📱 Updating application deployment..."
kubectl apply -f deployment.yml -n jenkins

# Restart application pods to ensure annotations are picked up
echo "🔄 Restarting application pods..."
kubectl rollout restart deployment/myapp-deployment -n jenkins

echo ""
echo "⏳ Waiting for deployments to be ready..."
kubectl rollout status deployment/prometheus-deployment -n jenkins
kubectl rollout status deployment/myapp-deployment -n jenkins

echo ""
echo "✅ Done! Checking pods..."
kubectl get pods -n jenkins

echo ""
echo "📊 Prometheus URL: http://localhost:30090"
echo "   Go to Status → Targets to verify scraping"
echo ""
echo "⏰ Wait 15-30 seconds, then check Prometheus targets!"
