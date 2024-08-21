# FORMATEADOR (UTF-8)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[System.Console]::InputEncoding = [System.Text.Encoding]::UTF8

# ADMINISTRADOR
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# UI
$host.UI.RawUI.WindowSize = New-Object Management.Automation.Host.Size(47, 10)
$host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size(10, 47)
$host.UI.RawUI.BackgroundColor = "DarkGreen"
$host.UI.RawUI.ForegroundColor = "White"
Clear-Host  

# SELECCION
$opciones = @(" = [ NUEVO  ] $([char]0x25B2) Establecer Menu de Windows $([char]0x25B2) =  ", " = [ LEGACY ] $([char]0x25BC) Establecer Menu de Windows $([char]0x25BC) = ")
$index = 0                                                                                                                                                  

function Mostrar-Menu {
    Clear-Host
    Write-Host " ============================================= " -ForegroundColor White
    Write-Host " BIENVENIDO AL CONFIGURADOR DE MENU DE WIN  11 " -ForegroundColor White
    Write-Host " ============================================= " -ForegroundColor White
    for ($i = 0; $i -lt $opciones.Length; $i++) {
        if ($i -eq $index) {
            Write-Host $opciones[$i] -ForegroundColor DarkGreen -BackgroundColor White
        } else {
            Write-Host $opciones[$i] -ForegroundColor White -BackgroundColor DarkGreen
        }
    }
    Write-Host " ============================================= " -ForegroundColor White
    Write-Host " =  Presiona ESC para cerrar el programa...  = " -ForegroundColor White
    Write-Host " ============================================= " -ForegroundColor White
    Write-Host " =_____________CREATED_BY_DEVNIS_G___________= " -ForegroundColor White -BackgroundColor DarkGreen
}

function Restart-Explorer {
    Write-Host "Reiniciando el explorador de Windows..." -ForegroundColor DarkGreen
    Stop-Process -Name explorer -Force
    Start-Process explorer
}

# MENU
:menu
do {
    Mostrar-Menu
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    switch ($key.VirtualKeyCode) {
        38 { # Codigo de Flecha hacia arriba
            if ($index -gt 0) {
                $index--
            }
        }
        40 { # Codigo de Flecha hacia abajo
            if ($index -lt $opciones.Length - 1) {
                $index++
            }
        }
        13 { # Codigo de Enter
            switch ($index) {
                0 {
                    Write-Host "Aplicando configuraciones para el Menu Nuevo..." -ForegroundColor Yellow
                    Remove-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -ErrorAction SilentlyContinue
                    Restart-Explorer
                    Write-Host "MENU NUEVO CONFIGURADO CON EXITO!" -ForegroundColor Green -BackgroundColor White
                    Start-Sleep -Seconds 1
                    goto menu
                }
                1 {
                    Write-Host "Aplicando configuraciones para el Menu Viejo..." -ForegroundColor Yellow
                    New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Value "" -Force
                    Restart-Explorer
                    Write-Host "MENU VIEJO CONFIGURADO CON EXITO!" -ForegroundColor Green -BackgroundColor White
                    Start-Sleep -Seconds 1
                    goto menu
                }
            }
        }
        27 { # Codigo de Escape
            Exit
        }
        default {
            Write-Host "Tecla no valida. Volviendo al menu..." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while ($true)
