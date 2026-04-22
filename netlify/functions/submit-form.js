const { createClient } = require('@supabase/supabase-js');

exports.handler = async (event) => {
  console.log('=== SUBMIT-FORM FUNCTION ===');
  console.log('Environment variables:', {
    SUPABASE_URL: process.env.SUPABASE_URL ? 'OK' : 'MISSING',
    SUPABASE_ANON_KEY: process.env.SUPABASE_ANON_KEY ? 'OK' : 'MISSING'
  });

  if (event.httpMethod !== 'POST') {
    return {
      statusCode: 405,
      body: JSON.stringify({ success: false, message: 'Método no permitido' })
    };
  }

  try {
    const supabaseUrl = process.env.SUPABASE_URL;
    const supabaseKey = process.env.SUPABASE_ANON_KEY;

    if (!supabaseUrl || !supabaseKey) {
      console.error('Missing environment variables');
      return {
        statusCode: 500,
        body: JSON.stringify({ 
          success: false, 
          message: 'Error de configuración del servidor'
        })
      };
    }

    const supabase = createClient(supabaseUrl, supabaseKey);
    const data = JSON.parse(event.body);

    console.log('Inserting data:', { surveyId: data.surveyId });

    const { error } = await supabase
      .from('fpsm_vap_responses')
      .insert([data]);

    if (error) {
      console.error('Supabase error:', error);
      return {
        statusCode: 400,
        body: JSON.stringify({ 
          success: false, 
          message: 'Error al guardar: ' + error.message
        })
      };
    }

    console.log('Data inserted successfully');
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        success: true,
        message: 'Su respuesta ha sido guardada exitosamente'
      })
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        success: false,
        message: 'Error al guardar la respuesta: ' + error.message
      })
    };
  }
};
