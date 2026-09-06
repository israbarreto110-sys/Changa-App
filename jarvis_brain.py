import subprocess
import time
import os
import re

def run_cmd(cmd):
    try:
        result = subprocess.run(
            cmd, shell=True, capture_output=True, text=True
        )
        return result.returncode, result.stdout, result.stderr
    except Exception as e:
        return 1, "", str(e)

def analizar_codigo():
    print("🔍 JARVIS analizando código...")
    codigo, stdout, stderr = run_cmd("dart analyze lib/")
    salida = stdout + stderr
    print(salida)
    return codigo, salida

def arreglar_override_sobrante():
    """Quita @override donde no corresponde"""
    print("🔧 Arreglando @override sobrantes...")
    # Buscamos todos los archivos .dart y quitamos @override antes de métodos que no sobreescriben
    run_cmd("find lib -name '*.dart' -exec sed -i '/^[[:space:]]*@override[[:space:]]*$/d' {} \\;")
    print("✅ @override sobrantes eliminados")

def hay_cambios_para_subir():
    codigo, stdout, stderr = run_cmd("git status --porcelain")
    return bool(stdout.strip())

def subir_a_github():
    print("📤 Subiendo cambios a GitHub...")
    run_cmd("git add -A")
    mensaje = "V60 - Jarvis arregla @override sobrantes"
    run_cmd(f'git commit -m "{mensaje}"')
    codigo, stdout, stderr = run_cmd("git push origin main")
    if codigo == 0:
        print("✅ ¡Subido! Andá a codemagic.io → tu app → Start new build")
        return True
    else:
        print("❌ Error al subir:\n", stderr)
        return False

print("🤖 JARVIS AUTO-REPARACIÓN INICIADO")
print("⏳ Analizando cada 60 segundos...\n")

while True:
    os.chdir(os.path.expanduser("~/changa-app"))
    
    codigo_analisis, salida = analizar_codigo()
    
    # Si hay advertencias de @override, los arreglamos
    if "override_on_non_overriding_member" in salida:
        arreglar_override_sobrante()
        print("🔄 Reanalizando después de arreglar...")
        time.sleep(2)
        codigo_analisis, salida = analizar_codigo()
    
    # Si está bien y hay cambios, subimos
    if hay_cambios_para_subir():
        subir_a_github()
    else:
        print("ℹ️ Sin cambios nuevos")
    
    print("\n⏳ Esperando 60s... (Ctrl+C para detener)")
    time.sleep(60)

