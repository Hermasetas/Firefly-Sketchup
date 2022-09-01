document.addEventListener("load", initUI);


function runPerspectiveRendering() {
    paramIndex = getElementValue('param_slider');
    sky_options = getSkyOptions();

    options = {
        'params_index': paramIndex,
        'sky_options': sky_options
    }

    sketchup.run_perspective_rendering(options);
    console.log(`Running: run_perspective_rendering(${options})`)
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


function getElementValue(id) {
    return document.getElementById(id).value
}

function initUI() {
    initSelect("hour_select", 0, 24, 1, 12);
    initSelect("minute_select", 0, 60, 5, 0);
    initSelect("day_select", 1, 32, 1, 0);
    initSelect("month_select", 1, 13, 1, 0);
    initSelect("year_select", 2010, 2030, 1, 10);

    //Timezones 
    let timezone_select = document.getElementById("timezone_select");
    for (let i = -12; i <= 14 ; i++) {
        let option = document.createElement("option");
        let s = Math.abs(i).toString();
        s = padStart(s, 2, "0");
        if (i < 0)
            option.text = `UTC-${s}`;
        else
            option.text = `UTC+${s}`;
        
        option.value = i;
        timezone_select.add(option);
    }
    timezone_select.selectedIndex = 12;
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