$(document).ready(function () {
  $(".mu-kids-submit-button").html("<kids-submit-button></kids-submit-button>");
  $(".mu-kids-reset-button").html("<kids-reset-button></kids-reset-button>");
  $(".mu-initial-state-header").append("<gs-attire-toggle-button></gs-attire-toggle-button>");

  mumuki.kids.registerStateScaler(($state, fullMargin, preferredWidth, preferredHeight) => {
    const $table = $state.find('.active gs-board > table');
    if(!$table.length) return setTimeout(() => mumuki.kids.scaleState($state, fullMargin));

    $table.css('transform', 'scale(1)');
    $table.css('transform', 'scale(' + Math.min(preferredWidth / $table.width(), preferredHeight / $table.height()) + ')');
  });

  mumuki.kids.registerBlocksAreaScaler(($blocks) => {
    const $blockArea = $blocks.find('#blocklyDiv');
    const $blockSvg = $blocks.find('.blocklySvg');

    $blockArea.width($blocks.width());
    $blockArea.height($blocks.height());

    $blockSvg.width($blocks.width());
    $blockSvg.height($blocks.height());
  });
});
