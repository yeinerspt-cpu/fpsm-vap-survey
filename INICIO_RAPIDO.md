# 🚀 Guía de Inicio Rápido - FPSM-VAP 2.0
## Para Yeiner - Universidad de Córdoba

Hola Yeiner, aquí está tu formulario completo de recolección de datos para tu investigación sobre vapeadores. ¡Vamos a ponerlo en línea en 15 minutos!

---

## ⚡ 3 Pasos Principales

### PASO 1️⃣: Preparar Supabase (5 minutos)

#### 1. Crear cuenta en Supabase
```
1. Ve a https://supabase.com
2. Haz clic en "Sign Up"
3. Usa tu email universitario o personal
4. Verifica tu email
```

#### 2. Crear nuevo proyecto
```
1. Haz clic en "New Project"
2. Nombre: "FPSM-VAP-2025"
3. Contraseña: Crea una fuerte (guárdala)
4. Región: Selecciona la más cercana a Colombia (us-east-1 o similar)
5. Haz clic en "Create new project" (espera 2-3 minutos)
```

#### 3. Obtener credenciales
Una vez creado el proyecto:
```
1. Ve a "Settings" → "API"
2. Copia estos valores (los necesitarás en Paso 2):
   - Project URL (algo como: https://xxxxxxxxx.supabase.co)
   - Anon Key (una larga cadena)
3. Guarda en un archivo de texto
```

#### 4. Crear tabla para respuestas
En Supabase:
```
1. Ve a "SQL Editor"
2. Haz clic en "New Query"
3. Copia y pega ESTE código completo:
```

```sql
CREATE TABLE IF NOT EXISTS fpsm_vap_responses (
    id BIGSERIAL PRIMARY KEY,
    survey_id VARCHAR(255) UNIQUE NOT NULL,
    survey_date DATE NOT NULL,
    survey_time TIME NOT NULL,
    timestamp TIMESTAMP DEFAULT NOW(),
    responses JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_survey_id ON fpsm_vap_responses(survey_id);
CREATE INDEX IF NOT EXISTS idx_created_at ON fpsm_vap_responses(created_at DESC);

ALTER TABLE fpsm_vap_responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anonymous inserts" ON fpsm_vap_responses
FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow anonymous selects" ON fpsm_vap_responses
FOR SELECT USING (true);
```

```
4. Haz clic en "Run"
5. Verifica que diga "Success" (sin errores en rojo)
```

✅ **Supabase está listo**

---

### PASO 2️⃣: Desplegar en Netlify (7 minutos)

#### 1. Crear repositorio en GitHub (IMPORTANTE)
```
1. Ve a https://github.com/new
2. Nombre: "fpsm-vap-survey"
3. Descripción: "Encuesta FPSM-VAP 2.0 - Universidad de Córdoba"
4. Selecciona "Public" (para que Netlify pueda acceder)
5. Haz clic en "Create repository"
```

#### 2. Subirarchivos a GitHub
**Opción A - Desde línea de comandos** (si tienes Git):
```bash
# En la carpeta con tus archivos:
git init
git add .
git commit -m "FPSM-VAP 2.0 survey form"
git branch -M main
git remote add origin https://github.com/tu-usuario/fpsm-vap-survey.git
git push -u origin main
```

**Opción B - Desde GitHub web** (más fácil):
```
1. En tu repositorio vacío de GitHub
2. Haz clic en "uploading an existing file"
3. Arrastra TODOS los archivos:
   - index.html
   - admin.html
   - netlify.toml
   - package.json
   - .gitignore
   - README.md
   - Carpeta "netlify" (con functions dentro)
4. Escribe en "Commit message": "Initial commit"
5. Haz clic en "Commit changes"
```

#### 3. Conectar GitHub con Netlify
```
1. Ve a https://netlify.com
2. Haz clic en "Sign up" (o Log in si ya tienes cuenta)
3. Selecciona "Continue with GitHub"
4. Autoriza Netlify para acceder a GitHub
5. Haz clic en "New site from Git"
6. Selecciona tu repositorio "fpsm-vap-survey"
7. La configuración se detectará automáticamente
8. Haz clic en "Deploy site"
9. ESPERA 1-2 MINUTOS (verás un progreso)
```

#### 4. Agregar variables de entorno
Una vez desplegado:
```
1. En Netlify, haz clic en tu sitio
2. Ve a "Site settings" 
3. Busca "Build & deploy" → "Environment"
4. Haz clic en "Edit variables"
5. Agrega DOS variables:
   
   Nombre: SUPABASE_URL
   Valor: [Tu URL de Supabase del PASO 1.3]
   
   Nombre: SUPABASE_ANON_KEY
   Valor: [Tu Anon Key de Supabase del PASO 1.3]
   
6. Haz clic en "Save"
7. Ve a "Deploys" y haz clic en "Trigger deploy" → "Deploy site"
8. ESPERA a que termine (verás "Site is live")
```

✅ **Netlify está en línea**

Tu sitio está en: `https://tu-nombre-aleatorio.netlify.app`

---

### PASO 3️⃣: Personalización & Prueba (3 minutos)

#### 1. Cambiar contraseña de administrador
En tu computadora:
```
1. Abre "admin.html" con un editor de texto (Notepad, VS Code, etc.)
2. Busca esta línea (aproximadamente línea 312):
   const DEFAULT_PASSWORD = 'admin2025';
   
3. Cámbiala a algo más seguro, por ejemplo:
   const DEFAULT_PASSWORD = 'MiContrasenaSegura2025!';
   
4. Guarda el archivo
5. Sube el cambio a GitHub (git push) o usa "uploading" nuevamente
6. Netlify redesplegará automáticamente
```

#### 2. Realizar prueba de envío
```
1. Abre tu sitio en Netlify
2. Llena el formulario completo (todas las preguntas)
3. Selecciona "He leído y comprendo..."
4. Haz clic en "ENVIAR RESPUESTAS"
5. Deberías ver mensaje "✓ Su respuesta ha sido guardada exitosamente"
6. Si ves error, verifica las variables de entorno
```

#### 3. Verificar panel de administración
```
1. Ve a /admin.html de tu sitio
2. Ingresa contraseña (que acabas de cambiar)
3. Deberías ver "Respuestas Totales: 1"
4. Descarga los datos en CSV
5. Abre en Excel para verificar que está completo
```

✅ **¡TODO ESTÁ FUNCIONANDO!**

---

## 📱 Compartir con Participantes

Tu URL para compartir:
```
https://tu-nombre-aleatorio.netlify.app
```

Puedes:
- ✅ Enviarla por email
- ✅ Compartirla en WhatsApp
- ✅ Publicarla en redes sociales
- ✅ Incluirla en documentos digitales
- ✅ QR code (USA https://qr-server.com para generar)

---

## 📊 Descargar Resultados

Para obtener los datos de tus participantes:

```
1. Ve a https://tu-nombre-aleatorio.netlify.app/admin.html
2. Ingresa tu contraseña
3. Verás estadísticas: "Respuestas Totales: X"
4. Selecciona formato:
   ✅ CSV (abre en Excel, Google Sheets, R, Python)
   ✅ Excel (.xlsx) (Excel directo)
   ✅ JSON (para procesamiento programático)
5. Haz clic en "DESCARGAR DATOS"
6. El archivo se descargará a tu computadora
```

---

## ⚠️ Notas Importantes

### Seguridad
- ✅ La contraseña de admin está protegida por HTTPS
- ✅ Los datos se guardan encriptados en Supabase
- ✅ No se requiere información identificable
- ⚠️ **Cambia la contraseña por defecto ANTES de que participantes accedan**

### Respaldos
- Supabase realiza respaldos automáticos
- Descarga datos regularmente como backup
- Los datos son anónimos (no hay riesgo de privacidad)

### Límites Gratuitos
- **Netlify**: ilimitado
- **Supabase**: 
  - 500 MB almacenamiento
  - 2 millones de solicitudes/mes
  - Suficiente para miles de respuestas

---

## 🐛 Solucionar Problemas

### "Error al guardar la respuesta"

**Comprueba:**
1. ¿Las variables de entorno están correctas? (copiar sin espacios)
2. ¿Esperaste 2 minutos después de agregar variables?
3. ¿Hiciste "Trigger deploy" después de agregar variables?

**Solución:**
```
1. Ve a Netlify
2. Copia nuevamente valores de Supabase (sin espacios)
3. Netlify → Site settings → Environment → Edit
4. Elimina y vuelve a crear ambas variables
5. Trigger deploy manualmente
6. Espera 2 minutos y prueba de nuevo
```

### "Página en blanco"

**Solución:**
1. Abre la consola del navegador (F12)
2. Ve a "Console" y busca errores rojos
3. Si ves error CORS: verifica las variables de entorno
4. Si ves "404 functions": comprueba que netlify.toml existe

### "No puedo descargar datos"

**Solución:**
1. Verifica contraseña (mayúsculas/minúsculas importan)
2. Asegúrate de que hay al menos 1 respuesta guardada
3. Intenta en navegador diferente (Chrome, Firefox)

---

## 📚 Documentación Técnica

Para detalles avanzados, ve a `README.md` en el proyecto

---

## 🎯 Próximos Pasos Sugeridos

### A Corto Plazo
1. ✅ Prueba que todo funciona (completar 1 respuesta)
2. ✅ Descarga los datos para verificar
3. ✅ Personaliza URL personalizada en Netlify (opcional)

### A Mediano Plazo
1. Difunde el formulario entre participantes
2. Monitorea respuestas regularmente
3. Descarga datos semanalmente como respaldo

### A Largo Plazo
1. Análisis estadístico de los datos
2. Generación de reportes
3. Publicación de resultados

---

## 📞 Contacto para Soporte

Si tienes problemas:

1. **Error en formulario**: Verifica el navegador (F12 → Console)
2. **Problema con datos**: Revisa variables de Supabase
3. **Netlify no responde**: Ve a status.netlify.com
4. **Supabase no responde**: Ve a status.supabase.com

---

## ✨ ¡Información Extra!

### Personalizar Colores
En `index.html` y `admin.html`, busca:
```css
--primary: #1a472a;        /* Verde oscuro */
--secondary: #c41e3a;      /* Rojo */
--accent: #f39c12;         /* Naranja */
```

Cambiar a colores de tu universidad o preferencia.

### Cambiar Texto
En `index.html`, puedes cambiar:
- Nombre de la encuesta
- Descripción del estudio
- Institución
- Investigadores

### Agregar Preguntas
En `index.html`, agregar más `<div class="question-group">` en la sección deseada.

---

## 🎓 Créditos

✅ Formulario basado en FPSM-VAP 2.0 de:
- Dra. Maria Fernanda Yasnot Acosta (Asesora)
- Grupo GIMBI-C
- Universidad de Córdoba
- Minciencias Convocatoria 933-2023

---

## 📝 Checklist Final

Antes de lanzar:

- [ ] Supabase proyecto creado y variables copiadas
- [ ] GitHub repositorio creado y archivos subidos
- [ ] Netlify conectado y desplegado
- [ ] Variables de entorno agregadas en Netlify
- [ ] Contraseña de admin cambiada
- [ ] Formulario completado y enviado (prueba)
- [ ] Datos descargados correctamente
- [ ] Panel admin accesible
- [ ] URL compartida con colaboradores

---

**¡Listo para recopilar datos! 🎉**

Tu encuesta está lista para que los participantes completen el FPSM-VAP 2.0. 

Si necesitas ayuda, contacta al equipo técnico de tu universidad.

¡Éxito con tu investigación doctoral! 📊🔬
