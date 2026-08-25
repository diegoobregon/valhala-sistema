$base = "http://localhost:8080/api/v1"
function Paso($nombre, $bloque) {
    try { $r = & $bloque; Write-Host "[OK]   $nombre" -ForegroundColor Green; return $r }
    catch { Write-Host "[FAIL $($_.Exception.Response.StatusCode.value__)] $nombre" -ForegroundColor Red; return $null }
}

$login = Paso "LOGIN (JWT)" { Invoke-RestMethod -Method Post -Uri "$base/auth/login" -ContentType "application/json" -Body '{"email":"admin@valhala.pe","password":"admin123"}' }
if (-not $login) { Write-Host "Backend no responde o login fallo."; exit }
$h = @{ Authorization = "Bearer $($login.token)" }

Paso "EQUIPOS protegido (RNF-05)" { Invoke-RestMethod -Uri "$base/equipos" -Headers $h } | Out-Null

$res = Paso "RESERVA nueva (RF-01)" { Invoke-RestMethod -Method Post -Uri "$base/reservas" -Headers $h -ContentType "application/json" -Body '{"idItemContrato":3,"fechaInicio":"2026-09-01","fechaFin":"2026-09-05"}' }

Paso "COLISION (409 = exito esperado)" { Invoke-RestMethod -Method Post -Uri "$base/reservas" -Headers $h -ContentType "application/json" -Body '{"idItemContrato":3,"fechaInicio":"2026-09-02","fechaFin":"2026-09-06"}' } | Out-Null

if ($res) {
    $co = Paso "CHECKOUT (RF-06 valida SOAT)" { Invoke-RestMethod -Method Post -Uri "$base/transacciones/checkout" -Headers $h -ContentType "application/json" -Body ('{"idReserva":' + $res.idReserva + ',"horometroInicial":9320.75}') }
    if ($co) {
        $liq = Paso "CHECKIN + LIQUIDACION (RF-05)" { Invoke-RestMethod -Method Post -Uri "$base/transacciones/checkin" -Headers $h -ContentType "application/json" -Body ('{"idSalida":' + $co.idSalida + ',"horometroFinal":9450.00}') }
        if ($liq) { Write-Host "=== LIQUIDACION GENERADA ===" -ForegroundColor Yellow; $liq | ConvertTo-Json -Depth 3 }
    }
}
Write-Host "==== PRUEBA GENERAL TERMINADA ===="