Blockly.HSV_SATURATION = 0.64;
Blockly.HSV_VALUE = 1;

Blockly.MUMUKI_COLORS = {
  pink: 346,
  blue: 204,
  yellow: 40,
}

Blockly.GOBSTONES_COLORS.program =            Blockly.MUMUKI_COLORS.pink;
Blockly.GOBSTONES_COLORS.interactiveProgram = Blockly.MUMUKI_COLORS.pink;
Blockly.GOBSTONES_COLORS.interactiveBinding = Blockly.MUMUKI_COLORS.pink;

Blockly.GOBSTONES_COLORS.controlStructure =   Blockly.MUMUKI_COLORS.yellow;
Blockly.GOBSTONES_COLORS.primitiveCommand =   Blockly.MUMUKI_COLORS.yellow;
Blockly.GOBSTONES_COLORS.complete =           Blockly.MUMUKI_COLORS.yellow;
Blockly.GOBSTONES_COLORS.expression =         Blockly.MUMUKI_COLORS.yellow;
Blockly.GOBSTONES_COLORS.assignation =        Blockly.MUMUKI_COLORS.yellow;

Blockly.GOBSTONES_COLORS.literalExpression =  Blockly.MUMUKI_COLORS.blue;

$(document).ready(() => {
  $(".mu-kids-submit-button").html("<kids-submit-button></kids-submit-button>");
});
