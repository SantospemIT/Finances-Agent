from openai import OpenAI
import sqlite3
import matplotlib.pyplot as plt

# Configurar el cliente de OpenAI
client = OpenAI(
    api_key='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',
    organization='org-yUl6CfQGDoZuViS7eDezZual',
    project='proj_PKFj1TwbGSmDnZtjQcRhdgrQ',
)

# Crear la base de datos y la tabla de usuarios
def crear_base_datos():
    conn = sqlite3.connect('usuarios.db')
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            edad INTEGER,
            email TEXT,
            telefono TEXT
        )
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS finanzas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER,
            ingresos_mensuales REAL,
            gastos_mensuales REAL,
            activos_totales REAL,
            pasivos_totales REAL,
            FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
        )
    ''')
    conn.commit()
    conn.close()

# Registrar un nuevo usuario
def registrar_usuario(nombre, edad, email, telefono):
    if edad < 18:
        print("Gracias por tu interés, pero debes ser mayor de 18 años para usar este programa.")
        return
    conn = sqlite3.connect('usuarios.db')
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO usuarios (nombre, edad, email, telefono)
        VALUES (?, ?, ?, ?)
    ''', (nombre, edad, email, telefono))
    usuario_id = cursor.lastrowid
    conn.commit()
    conn.close()
    return usuario_id

# Solicitar datos financieros al usuario
def solicitar_datos_financieros(usuario_id):
    try:
        ingresos_mensuales = float(input("Ingresos Mensuales: "))
        gastos_mensuales = float(input("Gastos Mensuales: "))
        activos_totales = float(input("Activos Totales: "))
        pasivos_totales = float(input("Pasivos Totales: "))
        conn = sqlite3.connect('usuarios.db')
        cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO finanzas (usuario_id, ingresos_mensuales, gastos_mensuales, activos_totales, pasivos_totales)
            VALUES (?, ?, ?, ?, ?)
        ''', (usuario_id, ingresos_mensuales, gastos_mensuales, activos_totales, pasivos_totales))
        conn.commit()
        conn.close()
        return ingresos_mensuales, gastos_mensuales, activos_totales, pasivos_totales
    except ValueError:
        print("Por favor, ingresa valores numéricos válidos.")
        return solicitar_datos_financieros(usuario_id)

# Calcular y mostrar el análisis financiero
def analizar_situacion_financiera(ingresos, gastos, activos, pasivos):
    flujo_caja_mensual = ingresos - gastos
    patrimonio_neto = activos - pasivos
    print(f"\n--- Análisis de tu Situación Financiera ---")
    print(f"Ingresos Mensuales: ${ingresos:,.2f}")
    print(f"Gastos Mensuales: ${gastos:,.2f}")
    print(f"Flujo de Caja Mensual: ${flujo_caja_mensual:,.2f} (Ingresos - Gastos)")
    print(f"Activos Totales: ${activos:,.2f}")
    print(f"Pasivos Totales: ${pasivos:,.2f}")
    print(f"Patrimonio Neto: ${patrimonio_neto:,.2f} (Activos - Pasivos)")
    print("\nAnálisis:")
    if flujo_caja_mensual > 0:
        print(f"Tienes un flujo de caja mensual positivo de ${flujo_caja_mensual:,.2f}, lo cual indica que estás generando más ingresos de los que gastas.")
    else:
        print(f"Tienes un flujo de caja mensual negativo de ${flujo_caja_mensual:,.2f}, lo cual indica que estás gastando más de lo que generas.")
    if patrimonio_neto > 0:
        print("Tu patrimonio neto es sólido, lo que sugiere una buena salud financiera en general.")
    else:
        print("Tu patrimonio neto es negativo, lo que sugiere que tienes más deudas que activos.")
    print("\nAcciones a Tomar:")
    print("1. Maximiza tu flujo de caja: Considera aumentar tus ingresos (si es posible) o reducir tus gastos para generar un mayor flujo de caja mensual.")
    print("2. Diversifica tus inversiones: Asegúrate de que tus inversiones estén diversificadas en diferentes clases de activos para reducir el riesgo.")

# Solicitar datos del plan de inversión
def solicitar_plan_inversion():
    objetivos_financieros = input("Objetivos financieros (corto, mediano, largo plazo) Ejemplo Pagar Universidad: ")
    horizonte_inversion = input("Horizonte de inversión Tiempo que planeas mantener las inversiones. Meses : ")
    preferencias_inversion = input("Preferencias de inversión (acciones, bonos, bienes raíces, etc.): ")
    return objetivos_financieros, horizonte_inversion, preferencias_inversion

# Analizar y mostrar el plan de inversión
def analizar_plan_inversion(objetivos, horizonte, preferencias):
    print(f"\n--- Análisis de tu Plan de Inversión ---")
    print(f"Horizonte de Inversión: {horizonte}")
    print(f"Preferencias de Inversión: {preferencias}")
    print("\nAnálisis:")
    if horizonte.lower() == "corto plazo":
        print("Tu horizonte de inversión es a corto plazo, lo cual limita las opciones de inversión más riesgosas.")
    if "bienes raíces" in preferencias.lower():
        print("Tu preferencia por bienes raíces sugiere un enfoque en inversiones tangibles y posiblemente generadoras de ingresos (rentas).")
    print("\nAcciones a Tomar:")
    print("1. Considera otras opciones de inversión: Dado tu horizonte de inversión a corto plazo, explora opciones de inversión líquidas y de bajo riesgo, como fondos de inversión de renta fija o depósitos a plazo.")
    print("2. Investiga a fondo el mercado inmobiliario: Antes de invertir en bienes raíces, investiga a fondo el mercado, las tendencias y los posibles riesgos y rendimientos.")

# Solicitar datos de proyección de retiro
def solicitar_proyeccion_retiro():
    try:
        edad_actual = int(input("Edad actual: "))
        edad_retiro = int(input("Edad de retiro deseada: "))
        gastos_retiro_anuales = float(input("Gastos esperados durante el retiro (anuales): "))
        ahorros_actuales = float(input("Ahorros actuales para el retiro: "))
        tasa_rendimiento = float(input("Tasa de rendimiento esperada de las inversiones (% anual): ")) / 100
        return edad_actual, edad_retiro, gastos_retiro_anuales, ahorros_actuales, tasa_rendimiento
    except ValueError:
        print("Por favor, ingresa valores numéricos válidos.")
        return solicitar_proyeccion_retiro()

# Calcular el monto necesario para el retiro usando la Regla del 4%
def calcular_monto_necesario(gastos_retiro_anuales):
    return gastos_retiro_anuales / 0.04

# Calcular los ahorros futuros con interés compuesto
def calcular_ahorros_futuros(ahorros_actuales, tasa_rendimiento, años_restantes):
    return ahorros_actuales * (1 + tasa_rendimiento) ** años_restantes

# Analizar y mostrar la proyección de retiro
def analizar_proyeccion_retiro(edad_actual, edad_retiro, gastos_retiro_anuales, ahorros_actuales, tasa_rendimiento):
    años_restantes = edad_retiro - edad_actual
    monto_necesario = calcular_monto_necesario(gastos_retiro_anuales)
    ahorros_futuros = calcular_ahorros_futuros(ahorros_actuales, tasa_rendimiento, años_restantes)
    brecha = monto_necesario - ahorros_futuros

    print("\n--- Análisis de Proyección de Retiro ---")
    print(f"Edad actual: {edad_actual}")
    print(f"Edad de retiro deseada: {edad_retiro}")
    print(f"Años restantes para el retiro: {años_restantes}")
    print(f"Gastos anuales esperados durante el retiro: ${gastos_retiro_anuales:,.2f}")
    print(f"Monto necesario para el retiro (Regla del 4%): ${monto_necesario:,.2f}")
    print(f"Ahorros actuales: ${ahorros_actuales:,.2f}")
    print(f"Ahorros proyectados al retiro: ${ahorros_futuros:,.2f}")
    print(f"Brecha: ${brecha:,.2f}")

    if brecha <= 0:
        print("\n¡Felicidades! Estás en camino de alcanzar tu meta de retiro.")
    else:
        print("\nAcciones recomendadas para cerrar la brecha:")
        print(f"1. Aumenta tus ahorros mensuales: Considera ahorrar al menos ${(brecha / años_restantes) / 12:,.2f} adicionales por mes.")
        print(f"2. Incrementa tu tasa de rendimiento: Explora opciones de inversión con mayor rendimiento, como acciones o fondos indexados.")
        print(f"3. Retrasa tu edad de retiro: Extender tu horizonte de inversión puede reducir la brecha significativamente.")
        print(f"4. Reduce tus gastos de retiro: Ajusta tus expectativas de gastos para disminuir el monto necesario.")

# Función principal
def main():
    crear_base_datos()
    print("=== Bienvenido a la Calculadora Financiera ===")
    nombre = input("Nombre: ")
    edad = int(input("Edad: "))
    email = input("Email: ")
    telefono = input("Teléfono: ")
    usuario_id = registrar_usuario(nombre, edad, email, telefono)

    respuesta = input("\n¿Deseas evaluar tu situación financiera? (si/no): ").lower()
    if respuesta == 'si':
        ingresos, gastos, activos, pasivos = solicitar_datos_financieros(usuario_id)
        analizar_situacion_financiera(ingresos, gastos, activos, pasivos)

        plan_respuesta = input("\n¿Deseas evaluar tu plan de inversión? (si/no): ").lower()
        if plan_respuesta == 'si':
            objetivos, horizonte, preferencias = solicitar_plan_inversion()
            analizar_plan_inversion(objetivos, horizonte, preferencias)

        retiro_respuesta = input("\n¿Deseas evaluar tu proyección de retiro? (si/no): ").lower()
        if retiro_respuesta == 'si':
            edad_actual, edad_retiro, gastos_retiro, ahorros_retiro, tasa_rendimiento = solicitar_proyeccion_retiro()
            analizar_proyeccion_retiro(edad_actual, edad_retiro, gastos_retiro, ahorros_retiro, tasa_rendimiento)

    print("\nGracias por usar la Calculadora Financiera. ¡Hasta pronto!")

if __name__ == "__main__":
    main()
