$(document).ready(() => {
  $("#custom-editor").html("<gs-element-blockly />");

  const blockly = $("gs-element-blockly")[0];

  blockly.workspace.addChangeListener(() => {
    $("#custom-editor-value")[0].value = blockly.generateCode();
  });
});
