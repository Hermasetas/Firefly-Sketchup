function initUI() {
    randomizeGridName();
}

function updateFaceLabel(face_id) {
    if (face_id) {
        document.getElementById('face_label').innerText = 'FaceID: ' + face_id;
        document.getElementById('run_button').disabled = false;
    }
    else {
        document.getElementById('face_label').innerText = 'Please select a single face';
        document.getElementById('run_button').disabled = true;
    }
}

function createGrid() {
    let face_id = document.getElementById('face_label').innerText.substring(8)
    let name = getElementValue('name_input');
    let spacing = getElementValue('spacing_input');
    let height = getElementValue('height_input');

    console.log(face_id, name, spacing, height);
    sketchup.create_grid(face_id, name, spacing, height);

    randomizeGridName();
}

function getElementValue(id) {
    return document.getElementById(id).value;
}

function randomizeGridName() {
    let number = Math.floor(Math.random() * 10000);
    let name = 'Firefly grid #' + number;
    document.getElementById('name_input').value = name;
}