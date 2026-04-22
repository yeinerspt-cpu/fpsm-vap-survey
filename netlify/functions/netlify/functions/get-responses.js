const { createClient } = require('@supabase/supabase-js');

exports.handler = async (event) => {
  console.log('=== GET-RESPONSES FUNCTION ===');

  if (event.httpMethod !== 'GET') {
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
          message: 'Error de configuración'
        })
      };
    }

    const supabase = createClient(supabaseUrl, supabaseKey);

    const { data, error } = await supabase
      .from('fpsm_vap_responses')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Supabase error:', error);
      return {
        statusCode: 400,
        body: JSON.stringify({ 
          success: false, 
          message: 'Error al obtener datos: ' + error.message
        })
      };
    }

    console.log('Data retrieved:', data.length, 'rows');

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        success: true,
        count: data.length,
        data: data
      })
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        success: false,
        message: 'Error al obtener datos: ' + error.message
      })
    };
  }
};
