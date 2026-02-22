$ResourceGroup = "rg-finglow-dev"
$ClusterName = "aks-finflow-dev"

Write-Host ">>> 1. Pobieranie konfiguracji klastra AKS" -ForegroundColor Cyan
az aks get-credentials --resource-group $ResourceGroup --name $ClusterName --overwrite-existing

Write-Host ">>> 2. Dodawanie i aktualizacja repozytorium Helm dla Grafany" -ForegroundColor Cyan
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

Write-Host ">>> 3. Instalacja Grafany" -ForegroundColor Cyan
helm upgrade --install moja-grafana grafana/grafana -f grafana-values.yaml

Write-Host ">>> 4. Oczekiwanie na przydzielenie adresu IP przez Azure" -ForegroundColor Cyan
Start-Sleep -Seconds 15
$Svc = kubectl get svc moja-grafana
Write-Host $Svc -ForegroundColor Yellow

Write-Host ">>> 5. Wyciąganie hasła administratora" -ForegroundColor Cyan
$SecretB64 = kubectl get secret --namespace default moja-grafana -o jsonpath="{.data.admin-password}"
$Password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($SecretB64))

Write-Host "==========================================" -ForegroundColor Green
Write-Host "GOTOWE!" -ForegroundColor Green
Write-Host "Login: admin" -ForegroundColor Green
Write-Host "Hasło: $Password" -ForegroundColor Green
Write-Host "Sprawdź adres EXTERNAL-IP z tabeli wyżej i wpisz go w przeglądarce po połączeniu z VPN." -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green