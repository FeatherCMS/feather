document.addEventListener("keydown", function(e) {
    if ( (window.navigator.platform.match("Mac") ? e.metaKey : e.ctrlKey) && e.keyCode == 83 ) {
        e.preventDefault();
        document.forms[0].submit()
    }
}, false);

document.addEventListener("DOMContentLoaded", function() {
    
});

window.addEventListener('load', function() {
    var elem = document.getElementById('notification');
    if (elem != null) {
        setTimeout(function() {
            elem.classList.toggle('fade');
            //elem.parentNode.removeChild(elem);
        }, 1500);
    }
});

function toggleNavigation() {
    var x = document.getElementById("tray");
    if (x.className === "opened") {
        x.className = "closed";
    }
    else {
        x.className = "opened";
    }
}

function confirmDelete(path, id) {
  if (confirm("Press ok to confirm delete.")) {
     var xmlHttp = new XMLHttpRequest();
        xmlHttp.onreadystatechange = function() {
            if (xmlHttp.readyState != 4 || xmlHttp.status != 200) {
                return
            }
            console.warn(xmlHttp.responseText)
            var element = document.getElementById(id)
            var tr = element.parentElement.parentElement
            tr.parentNode.removeChild(tr)
        }
        xmlHttp.open("POST", path + id + "/delete/", true);
        xmlHttp.send(null);
  }
}

function chooseImage() {
    document.getElementById('imageDelete').value = false;
    document.getElementById('image').click();
}
function removeImage() {
    document.getElementById('image').value = null;
    document.getElementById('imageDelete').value = true;
    const element = document.getElementById('uploaded-image');
    if (element !== null) {
        element.parentNode.removeChild(element);
    }
}

const imageElement = document.getElementById("image")
if (imageElement !== null) {
    imageElement.onchange = function(event) {
        const file = event.target.files[0];
        const blobURL = URL.createObjectURL(file);
        let element = document.getElementById('uploaded-image');
        if (element === null) {
            var newElement = document.createElement("img");
            newElement.id = 'uploaded-image';
            const sibling = document.getElementById('choose-button');
            sibling.parentNode.insertBefore(newElement, sibling);
            element = newElement
        }
        element.src = blobURL;
    }
}
