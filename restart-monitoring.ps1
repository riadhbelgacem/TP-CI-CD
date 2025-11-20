# Restart Monitoring Stack to Apply Configuration Changes (PowerShell)

Write-Host "🔄 Restarting Prometheus and Application Pods..." -ForegroundColor Cyan

# Reapply Prometheus configuration
Write-Host "📊 Updating Prometheus configuration..." -ForegroundColor Yellow
kubectl apply -f prometheus-deployment.yml -n jenkins

# Restart Prometheus to reload config
Write-Host "🔄 Restarting Prometheus pod..." -ForegroundColor Yellow
kubectl rollout restart deployment/prometheus-deployment -n jenkins

# Reapply application deployment (to ensure annotations are applied)
Write-Host "📱 Updating application deployment..." -ForegroundColor Yellow
kubectl apply -f deployment.yml -n jenkins

# Restart application pods to ensure annotations are picked up
Write-Host "🔄 Restarting application pods..." -ForegroundColor Yellow
kubectl rollout restart deployment/myapp-deployment -n jenkins

Write-Host ""
Write-Host "⏳ Waiting for deployments to be ready..." -ForegroundColor Cyan
kubectl rollout status deployment/prometheus-deployment -n jenkins
kubectl rollout status deployment/myapp-deployment -n jenkins

Write-Host ""
Write-Host "✅ Done! Checking pods..." -ForegroundColor Green
kubectl get pods -n jenkins

Write-Host ""
Write-Host "📊 Prometheus URL: http://localhost:30090" -ForegroundColor Green
Write-Host "   Go to Status → Targets to verify scraping"
Write-Host ""
Write-Host "⏰ Wait 15-30 seconds, then check Prometheus targets!" -ForegroundColor Yellow
