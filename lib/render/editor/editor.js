const blockly = $("gs-element-blockly")[0];

blockly.workspace.addChangeListener(() => {
  $("#custom-value")[0].value = blockly.generateCode();
);
