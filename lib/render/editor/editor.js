$(document).ready(function () {

  $('#custom-editor').html("<gs-element-blockly />");

  function updateCustomEditorValue(blockly) {
    $('#custom-editor-metadata')[0].value = blockly.workspaceXml;
    $('#custom-editor-value')[0].value = blockly.generateCode();
  }

  function populateWorkspaceXml(blockly) {
    var $contentMetadata = $('#custom-editor-metadata');
    var input = $contentMetadata[0];
    if (input.value) {
      blockly.workspaceXml = input.value;
    }
  }

  function addBlockListener() {
    setTimeout(function () {
      var blockly = $('gs-element-blockly')[0];

      if (blockly && blockly.workspace) {
        populateWorkspaceXml(blockly);
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
