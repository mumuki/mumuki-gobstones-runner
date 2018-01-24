$(document).ready(function () {

  $('#custom-editor').html("<gs-element-blockly />");

  function updateCustomEditorValue(blockly) {
    $('#custom-editor-value')[0].value = blockly.generateCode();
  }

  function addBlockListener() {
    setTimeout(function () {
      var blockly = $('gs-element-blockly')[0];

      if (blockly && blockly.workspace) {
        blockly.workspace.addChangeListener(function () {
          updateCustomEditorValue(blockly);
        });
      } else {
        addBlockListener();
      }

    }, 50);
  }

  addBlockListener();
});
