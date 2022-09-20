function runPerspectiveRendering() {
    paramIndex = getElementValue('param_slider');
    params_label = ['Min', 'Fast', 'Accu', 'Accu+', 'Max'][paramIndex];
    sky_options = getSkyOptions();
    
    options = {
        'params_label': params_label,
        'sky_options': sky_options
    }
    
    sketchup.run_perspective_rendering(options);
    console.log(`Running: run_perspective_rendering(${options})`)
}

function updateCity(values) {
    if (values == null) {
        let city = getElementValue('city_select');
        sketchup.get_city(city);
    }
    else {
        setElementValue('lat_input', values.lat);
        setElementValue('long_input', values.long);

        let tzs = document.getElementById('timezone_select');
        for (let i = 0; i < tzs.length; i++) {
            if (values.time_zone == tzs.options[i].text) {
                tzs.selectedIndex = i;
                break;
            }
        }
    }
}

function showSkyDiv() {
    document.getElementById('sky_div').hidden = !document.getElementById('sky_checkbox').checked
}

function getSkyOptions() {
    if (!document.getElementById('sky_checkbox').checked)
        return null;
    
    let sky_options = {
        'lat': getElementValue('lat_input'),
        'long': getElementValue('long_input'),
        'timezone': getElementValue('timezone_select'),
        'hour': getElementValue('hour_select'),
        'minute': getElementValue('minute_select'),
        'day': getElementValue('day_select'),
        'month': getElementValue('month_select'),
        'year': getElementValue('year_select'),
        'type': getElementValue('skytype_select')
    }
    
    return sky_options;
}

function updateSkyOptions(sky_options) {
    if (!sky_options)
        return;
    
    setElementValue('lat_input', sky_options.lat);
    setElementValue('long_input', sky_options.long);
    setElementValue('timezone_select', sky_options.timezone);
    setElementValue('hour_select', sky_options.hour);
    setElementValue('minute_select', sky_options.minute);
    setElementValue('day_select', sky_options.day);
    setElementValue('month_select', sky_options.month);
    setElementValue('year_select', sky_options.year);
    setElementValue('skytype_select', sky_options.type);
}

function getElementValue(id) {
    return document.getElementById(id).value
}

function setElementValue(id, value) {
    document.getElementById(id).value = value;
}

function setElementValue(id, value) {
    document.getElementById(id).value = value;
}

function initUI() {
    initSelect("hour_select", 0, 24, 1, 12);
    initSelect("minute_select", 0, 60, 5, 0);
    initSelect("day_select", 1, 32, 1, 0);
    initSelect("month_select", 1, 13, 1, 0);
    initSelect("year_select", 2010, 2030, 1, 10);

    document.getElementById('timezone_select').selectedIndex = 14;

    updateCitySelect();
    sketchup.get_prev_sky_options();
}

function updateCitySelect(cities) {
    if(cities == null) {
        sketchup.get_city_list();
    }
    else {
        let city_select = document.getElementById('city_select');
        for (const city of cities) {
            let option = document.createElement('option');
            option.text = city;
            city_select.add(option);
        }
    }
}

function initSelect(id, start, end, inc, selectedIndex) {
    let select = document.getElementById(id);
    for (let i = start; i < end; i += inc) {
        let option = document.createElement("option")
        option.text = i;
        option.value = i;
        select.add(option);    
    }
    select.selectedIndex = selectedIndex;
}

function padStart(s, len, pad) {
    n_pad = len - s.length;
    if (n_pad < 1)
    return s;
    else
    return pad.repeat(n_pad) + s;
}