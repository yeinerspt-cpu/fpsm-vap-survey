-- ============================================================
-- FPSM-VAP 2.0 - Script de Configuración Supabase
-- Universidad de Córdoba - Minciencias 933-2023
-- ============================================================

-- INSTRUCCIONES:
-- 1. Accede a tu proyecto de Supabase (https://supabase.com)
-- 2. Ve a "SQL Editor" en el menú lateral izquierdo
-- 3. Haz clic en "New Query"
-- 4. Copia TODO este archivo (desde aquí hasta el final)
-- 5. Pega en el editor SQL
-- 6. Haz clic en "Run" (botón verde arriba a la derecha)
-- 7. Verifica que dice "Success" al final (sin errores rojos)

-- ============================================================
-- 1. CREAR TABLA DE RESPUESTAS
-- ============================================================

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

COMMENT ON TABLE fpsm_vap_responses IS 'Tabla para almacenar respuestas de la encuesta FPSM-VAP 2.0';
COMMENT ON COLUMN fpsm_vap_responses.survey_id IS 'ID único de la encuesta (generado automáticamente)';
COMMENT ON COLUMN fpsm_vap_responses.responses IS 'Respuestas en formato JSON';

-- ============================================================
-- 2. CREAR ÍNDICES PARA MEJOR RENDIMIENTO
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_survey_id ON fpsm_vap_responses(survey_id);
CREATE INDEX IF NOT EXISTS idx_created_at ON fpsm_vap_responses(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_survey_date ON fpsm_vap_responses(survey_date);

-- ============================================================
-- 3. CONFIGURAR SEGURIDAD (Row Level Security)
-- ============================================================

-- Habilitar RLS en la tabla
ALTER TABLE fpsm_vap_responses ENABLE ROW LEVEL SECURITY;

-- Política para permitir inserciones (sin autenticación)
CREATE POLICY "Allow anonymous inserts" ON fpsm_vap_responses
    FOR INSERT 
    WITH CHECK (true);

-- Política para permitir lecturas (solo para admin, en el futuro)
CREATE POLICY "Allow authenticated reads" ON fpsm_vap_responses
    FOR SELECT 
    USING (true);

-- Política para proteger actualizaciones
CREATE POLICY "Prevent updates" ON fpsm_vap_responses
    FOR UPDATE 
    USING (false);

-- Política para proteger eliminaciones
CREATE POLICY "Prevent deletes" ON fpsm_vap_responses
    FOR DELETE 
    USING (false);

-- ============================================================
-- 4. CREAR TABLA DE METADATOS (OPCIONAL)
-- ============================================================

CREATE TABLE IF NOT EXISTS fpsm_vap_metadata (
    id BIGSERIAL PRIMARY KEY,
    key VARCHAR(255) UNIQUE NOT NULL,
    value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Metadatos iniciales
INSERT INTO fpsm_vap_metadata (key, value) VALUES 
    ('version', '2.0'),
    ('investigador_principal', 'Dra. Maria Fernanda Yasnot Acosta'),
    ('institucion', 'Universidad de Córdoba'),
    ('grupo_investigacion', 'GIMBI-C'),
    ('convocatoria', 'Minciencias 933-2023'),
    ('codigo_proyecto', '100890'),
    ('ano_inicio', '2024'),
    ('ano_fin', '2025')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

-- ============================================================
-- 5. CREAR FUNCIÓN PARA ESTADÍSTICAS
-- ============================================================

CREATE OR REPLACE FUNCTION get_fpsm_stats()
RETURNS TABLE (
    total_respuestas BIGINT,
    ultima_respuesta TIMESTAMP,
    respuestas_hoy BIGINT,
    respuestas_semana BIGINT,
    respuestas_mes BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_respuestas,
        MAX(created_at) as ultima_respuesta,
        COUNT(*) FILTER (WHERE created_at::date = CURRENT_DATE)::BIGINT as respuestas_hoy,
        COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '7 days')::BIGINT as respuestas_semana,
        COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '30 days')::BIGINT as respuestas_mes
    FROM fpsm_vap_responses;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 6. CREAR VISTA PARA EXPORTACIÓN
-- ============================================================

CREATE OR REPLACE VIEW fpsm_vap_export AS
SELECT 
    survey_id,
    survey_date,
    survey_time,
    timestamp,
    (responses->>'age')::INTEGER as edad,
    responses->>'biologicalSex' as sexo_biologico,
    responses->>'genderIdentity' as identidad_genero,
    responses->>'educationLevel' as nivel_educativo,
    responses->>'usageStatus' as estado_uso,
    responses->>'usageFrequency' as frecuencia_uso,
    responses->>'nicotineContent' as contenido_nicotina,
    responses->>'dualUse' as uso_dual,
    responses->>'substanceUse' as uso_sustancias,
    created_at
FROM fpsm_vap_responses
ORDER BY created_at DESC;

-- ============================================================
-- 7. INFORMACIÓN IMPORTANTE
-- ============================================================

/*
INSTRUCCIONES PARA USO POSTERIOR:

1. INSERTAR RESPUESTAS:
   INSERT INTO fpsm_vap_responses (survey_id, survey_date, survey_time, responses)
   VALUES ('FPSM-VAP-123456', '2025-04-21', '14:30:00', '{"age": 25, ...}');

2. CONSULTAR TODAS LAS RESPUESTAS:
   SELECT * FROM fpsm_vap_responses ORDER BY created_at DESC;

3. CONSULTAR ESTADÍSTICAS:
   SELECT * FROM get_fpsm_stats();

4. FILTRAR POR FECHA:
   SELECT * FROM fpsm_vap_responses 
   WHERE created_at >= '2025-04-21' AND created_at <= '2025-04-22';

5. EXPORTAR COMO CSV (en pgAdmin o similar):
   SELECT * FROM fpsm_vap_export;

6. CONTAR RESPUESTAS POR ESTADO DE USO:
   SELECT responses->>'usageStatus' as estado, COUNT(*) as total
   FROM fpsm_vap_responses
   GROUP BY responses->>'usageStatus';

7. ESTADÍSTICAS DE EDAD:
   SELECT 
       (responses->>'age')::INTEGER as edad,
       COUNT(*) as total
   FROM fpsm_vap_responses
   GROUP BY edad
   ORDER BY edad;

VARIABLES DE CONEXIÓN (para tu aplicación):
- Host: [Tu URL de Supabase sin https://]
- Database: postgres
- Usuario: postgres
- Contraseña: [Tu contraseña de proyecto]
- Puerto: 5432
*/

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================

-- Si ves este mensaje sin errores rojos, ¡todo está configurado correctamente!
-- Puedes cerrar esta pestaña y proceder con Netlify
