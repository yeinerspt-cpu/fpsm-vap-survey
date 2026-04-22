const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

exports.handler = async (event) => {
  if (event.httpMethod !== 'GET') {
    return {
      statusCode: 405,
      body: JSON.stringify({ message: 'Método no permitido' })
    };
  }

  try {
    const { data, error } = await supabase
      .from('fpsm_vap_responses')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error Supabase:', error);
      throw error;
    }

    const transformedData = data.map(item => ({
      surveyId: item.survey_id,
      surveyDate: item.survey_date,
      surveyTime: item.survey_time,
      timestamp: item.timestamp || item.created_at,
      responses: item.responses
    }));

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        success: true,
        count: transformedData.length,
        data: transformedData
      })
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        success: false,
        message: 'Error al obtener datos',
        error: error.message
      })
    };
  }
};
