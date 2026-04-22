# FPSM-VAP 2.0 - Encuesta de Investigación
## Factores Psicosociales y Microbiológicos Asociados al Uso de Vapeadores

Solución completa para recolección, almacenamiento y descarga de datos de encuestas de investigación usando Netlify y Supabase.

---

## 📋 Contenido del Proyecto

```
.
├── index.html                    # Formulario principal (72 preguntas)
├── admin.html                    # Panel de administración
├── netlify.toml                  # Configuración de Netlify
├── package.json                  # Dependencias
├── netlify/
│   └── functions/
│       ├── submit-form.js        # API para guardar respuestas
│       └── get-responses.js      # API para obtener respuestas
├── README.md                     # Este archivo
└── .gitignore                    # Archivos a ignorar en Git
```

---

## 🚀 Inicio Rápido

### Requisitos Previos
- Cuenta de **Netlify** (gratuita)
- Cuenta de **Supabase** (gratuita)
- Git instalado
- Node.js 14+ (opcional, para desarrollo local)

### Paso 1: Configurar Supabase

#### 1.1 Crear proyecto en Supabase
1. Ir a [supabase.com](https://supabase.com)
2. Iniciar sesión o crear cuenta
3. Crear nuevo proyecto
4. Guardar **Project URL** y **Anon Key** (los necesitarás después)

#### 1.2 Crear tabla para respuestas

En el editor SQL de Supabase, ejecutar:

```sql
CREATE TABLE fpsm_vap_responses (
    id BIGSERIAL PRIMARY KEY,
    survey_id VARCHAR(255) UNIQUE NOT NULL,
    survey_date DATE NOT NULL,
    survey_time TIME NOT NULL,
    timestamp TIMESTAMP DEFAULT NOW(),
    responses JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_survey_id ON fpsm_vap_responses(survey_id);
CREATE INDEX idx_created_at ON fpsm_vap_responses(created_at DESC);

-- Política RLS para seguridad
ALTER TABLE fpsm_vap_responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anonymous inserts" ON fpsm_vap_responses
FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow anonymous selects" ON fpsm_vap_responses
FOR SELECT USING (true);
```

---

### Paso 2: Desplegar en Netlify

#### 2.1 Preparar repositorio Git

```bash
# Clonar este proyecto o inicializar nuevo repositorio
git init
git add .
git commit -m "Initial commit: FPSM-VAP 2.0 survey form"
```

#### 2.2 Empujar a GitHub (o GitLab)

```bash
# Crear nuevo repositorio en GitHub
git remote add origin https://github.com/tu-usuario/fpsm-vap-survey.git
git branch -M main
git push -u origin main
```

#### 2.3 Conectar con Netlify

1. Ir a [netlify.com](https://netlify.com)
2. Iniciar sesión con GitHub
3. Hacer clic en "New site from Git"
4. Seleccionar tu repositorio
5. Dejar configuración por defecto (Netlify detectará netlify.toml automáticamente)
6. Hacer clic en "Deploy site"

#### 2.4 Configurar Variables de Entorno

En el sitio de Netlify:
1. Ir a **Site settings** → **Build & deploy** → **Environment**
2. Hacer clic en **Edit variables**
3. Agregar:
   - `SUPABASE_URL`: Tu URL de Supabase (paso 1.1)
   - `SUPABASE_ANON_KEY`: Tu clave anon de Supabase (paso 1.1)

4. Hacer clic en "Redeploy site"

---

### Paso 3: Personalizar Seguridad

#### 3.1 Cambiar contraseña de administrador

En `admin.html`, buscar línea:
```javascript
const DEFAULT_PASSWORD = 'admin2025';
```

**Cambiar a una contraseña segura y única.**

#### 3.2 Considerar autenticación adicional

Para mayor seguridad, implementar:
- Autenticación con Google/GitHub en panel admin
- Tokens JWT para APIs
- Rate limiting en funciones

---

## 🎯 Características

### ✅ Formulario Completo
- **72 preguntas** divididas en 11 secciones temáticas
- **Consentimiento informado** obligatorio
- **Escalas Likert** con validación
- **Diseño responsivo** (móvil, tablet, desktop)
- **Generación automática** de ID de encuesta
- **Validación en tiempo real** de campos

### ✅ Almacenamiento de Datos
- Almacenamiento en **Supabase** (base de datos PostgreSQL)
- Fallback a **localStorage** para compatibilidad
- Timestamps automáticos
- Respuestas en formato JSON

### ✅ Panel de Administración
- **Autenticación protegida** por contraseña
- **Estadísticas en vivo** (total respuestas, última respuesta)
- **Descarga múltiple formatos**:
  - CSV (compatible con Excel, Google Sheets)
  - Excel (.xlsx)
  - JSON
- **Filtros de exportación**:
  - Incluir/excluir timestamps
  - Incluir/excluir metadatos
- **Interfaz intuitiva** y segura

---

## 📊 Secciones del Formulario

1. **Datos Sociodemográficos** - Edad, género, educación, estrato
2. **Patrones de Uso** - Frecuencia, sustancias, estado actual
3. **Conocimientos** - Escala Likert sobre información del vapeo
4. **Influencia Social** - Presión de pares, influencers, ambiente
5. **Percepción de Riesgo** - Evaluación de riesgos sanitarios
6. **Placer Percibido** - Expectativas y satisfacción
7. **Bienestar Emocional** - PHQ-8 modificado
8. **Dependencia** - Síntomas de adicción
9. **Autoeficacia** - Capacidad de cambio
10. **Salud Oral/Respiratoria** - Indicadores clínicos
11. **Contexto Oral** - Higiene y hábitos

---

## 🔒 Seguridad

- **HTTPS automático** en Netlify
- **Variables de entorno** no expuestas en código
- **RLS (Row Level Security)** en Supabase
- **CSP (Content Security Policy)** configurada
- **CORS** restringido
- **Validación** servidor y cliente
- **Datos anónimos** (sin identificadores personales requeridos)

---

## 🛠️ Desarrollo Local

### Instalar Netlify CLI

```bash
npm install -g netlify-cli
```

### Clonar y configurar

```bash
git clone tu-repo
cd fpsm-vap-survey
npm install
```

### Crear archivo .env.local

```
SUPABASE_URL=tu_url_supabase
SUPABASE_ANON_KEY=tu_clave_anon
```

### Ejecutar localmente

```bash
netlify dev
```

El sitio estará disponible en `http://localhost:8888`

---

## 📈 Análisis de Datos

### Descargar datos

1. Abrir `/admin.html`
2. Ingresar contraseña (por defecto: `admin2025`)
3. Seleccionar formato (CSV, Excel o JSON)
4. Hacer clic en "Descargar datos"

### Procesar en Excel

```excel
=XLOOKUP("age", headers, values)  // Buscar respuesta específica
=COUNTIFS(datos, criterio)         // Análisis por categoría
=PIVOT TABLE                        // Tablas dinámicas
```

### Procesar en Python

```python
import pandas as pd

# Cargar CSV
df = pd.read_csv('FPSM-VAP_respuestas_2025-04-21.csv')

# Estadísticas básicas
print(df.describe())

# Análisis por género
gender_analysis = df.groupby('biologicalSex').size()

# Exportar a Excel con gráficos
with pd.ExcelWriter('analisis.xlsx') as writer:
    df.to_excel(writer, sheet_name='Respuestas')
```

---

## 🔧 Troubleshooting

### "Error al guardar la respuesta"

**Solución:**
1. Verificar que Supabase está en línea
2. Confirmar variables de entorno en Netlify
3. Revisar consola de navegador (F12) para detalles

### "Función no encontrada (404)"

**Solución:**
1. Confirmar `netlify.toml` está correcto
2. Verificar que funciones están en `netlify/functions/`
3. Redeploy el sitio manualmente

### "Los datos no se descargan"

**Solución:**
1. Cambiar contraseña de admin si es necesario
2. Verificar que hay al menos una respuesta guardada
3. Usar navegador diferente

---

## 📞 Contacto & Soporte

- **Investigadores**: GIMBI-C (Grupo de Investigaciones Microbiológicas y Biomédicas de Córdoba)
- **Universidad**: Universidad de Córdoba
- **Financiador**: Minciencias - Convocatoria 933-2023
- **Código**: 100890

---

## 📝 Licencia

Este proyecto es de uso exclusivo para investigación con aprobación ética. 

---

## 🎓 Créditos

Desarrollado para el estudio:
**"Factores Psicosociales y Microbiológicos Asociados al Uso de Vapeadores"**

Investigador Principal: Dra. Maria Fernanda Yasnot Acosta
Doctorando: Yeiner [Apellido]
Colaboraciones: Lehman College (NY), Universidad de Sucre

---

## ✅ Checklist de Implementación

- [ ] Crear cuenta y proyecto en Supabase
- [ ] Ejecutar script SQL en Supabase
- [ ] Obtener SUPABASE_URL y SUPABASE_ANON_KEY
- [ ] Crear repositorio en GitHub/GitLab
- [ ] Conectar con Netlify
- [ ] Configurar variables de entorno
- [ ] Cambiar contraseña de administrador
- [ ] Realizar prueba de envío de formulario
- [ ] Verificar descarga de datos en panel admin
- [ ] Configurar dominio personalizado (opcional)
- [ ] Implementar respaldo de datos (recomendado)

---

## 🔄 Actualización del Formulario

Para agregar nuevas preguntas:

1. Agregar `<div class="question-group">` en sección correspondiente
2. Asignar `name` único al control de entrada
3. Validar en JavaScript si es necesario
4. Redeploy a Netlify

---

## 📦 Exportar Configuración

Para migrar a otro sitio:

```bash
# Exportar datos de Supabase
pg_dump postgresql://usuario:contraseña@host/base_datos > backup.sql

# Clonar repositorio
git clone tu-repo nuevo-sitio
cd nuevo-sitio
git push -u origin main
```

---

## 🎉 ¡Listo!

Tu encuesta está en línea y lista para recolectar datos. 

**URL principal**: `https://tu-sitio-netlify.netlify.app`
**Panel admin**: `https://tu-sitio-netlify.netlify.app/admin.html`

¡Buena suerte con tu investigación! 🔬📊
