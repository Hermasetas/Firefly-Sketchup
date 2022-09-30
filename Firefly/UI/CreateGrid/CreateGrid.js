function initUI() {

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

    sketchup.create_grid(face_id, name, spacing, height);
}

function getElementValue(id) {
    return document.getElementById(id).value;
}