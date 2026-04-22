const { createClient } = require('@supabase/supabase-js');

exports.handler = async (event) => {
  try {
    const supabaseUrl = process.env.SUPABASE_URL;
    const supabaseKey = process.env.SUPABASE_ANON_KEY;

    if (!supabaseUrl || !supabaseKey) {
      return {
        statusCode: 500,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ success: false, count: 0, data: [] })
      };
    }

    const supabase = createClient(supabaseUrl, supabaseKey);
    const { data } = await supabase
      .from('fpsm_vap_responses')
      .select('*')
      .order('created_at', { ascending: false });

    return {
      statusCode: 200,
      headers: { 
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        success: true,
        count: data ? data.length : 0,
        data: data || []
      })
    };
  } catch (error) {
    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ success: false, count: 0, data: [] })
    };
  }
};
