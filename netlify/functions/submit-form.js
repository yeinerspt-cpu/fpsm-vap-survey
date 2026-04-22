const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

exports.handler = async (event) => {
    if (event.httpMethod !== 'POST') {
        return {
            statusCode: 405,
            body: JSON.stringify({ message: 'Método no permitido' })
        };
    }

    try {
        const data = JSON.parse(event.body);

        if (!data.surveyId || !data.responses) {
            return {
                statusCode: 400,
                body: JSON.stringify({ message: 'Datos incompletos' })
            };
        }

        const record = {
            survey_id: data.surveyId,
            survey_date: data.surveyDate,
            survey_time: data.surveyTime,
            timestamp: data.timestamp,
            responses: data.responses,
            created_at: new Date().toISOString()
        };

        const { data: result, error } = await supabase
            .from('fpsm_vap_responses')
            .insert([record]);

        if (error) {
            console.error('Error Supabase:', error);
            throw error;
        }

        return {
            statusCode: 200,
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                message: 'Respuesta guardada exitosamente',
                surveyId: data.surveyId
            })
        };

    } catch (error) {
        console.error('Error:', error);

        return {
            statusCode: 500,
            body: JSON.stringify({
                message: 'Error al guardar la respuesta',
                error: error.message
            })
        };
    }
};
