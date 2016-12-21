function loadIfNotLoaded(flag, base64) {
  if (!window[flag]) {
    dynamicLoad(atob(base64));
    window[flag] = true;
  }
}

function dynamicLoad(html) {
  var element = document.createElement("div");
  element.innerHTML = html;

  // Insert the html on the document
  var firstChild = document.body.childNodes[0];
  document.body.insertBefore(element, firstChild);

  // Recursively force the execution of <script> tags
  toArray(
    element.getElementsByTagName("script")
  ).filter(function(it) {
    return !it.type || it.type.toLowerCase === "text/javascript";
  }).forEach(evalScriptNode);
}

function evalScriptNode(son) {
  // Clone the <script> dom element
  var code = son.text || son.textContent || son.innerHTML || "";
  var newSon = document.createElement("script");
  newSon.innerHTML = code;

  // Reinsert to the dom to force the browser to execute it
  var father = son.parentNode;
  var position = toArray(father.childNodes).indexOf(son);
  father.removeChild(son);
  father.insertBefore(newSon, father.childNodes[position]);
}

function toArray(obj) {
  var array = [];
  for (var i = obj.length >>> 0; i--;)
    array[i] = obj[i];
  return array;
}
