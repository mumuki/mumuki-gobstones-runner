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

  mumuki.I18n.register({
    'es': {
      'kindergarten_passed': '¡Tu programa está muy bien!',
      'kindergarten_passed_with_warnings': 'Tu programa está bien ¡pero se puede mejorar!',
      'kindergarten_failed': 'Hay un error en tu programa. ¡Intentá de nuevo!',
      'kindergarten_errored': 'Hay un error en tu programa. ¡Intentá de nuevo!',
    },
    'es-CL': {
      'kindergarten_passed': '¡Tu programa está muy bien!',
      'kindergarten_passed_with_warnings': 'Tu programa está bien ¡pero se puede mejorar!',
      'kindergarten_failed': 'Hay un error en tu programa. ¡Intenta de nuevo!',
      'kindergarten_errored': 'Hay un error en tu programa. ¡Intenta de nuevo!'
    },
    'en': {
      'kindergarten_passed': 'Your program is very good!',
      'kindergarten_passed_with_warnings': 'Your program is good. But it can be improved!',
      'kindergarten_failed': 'There is an error in your program. Try again!',
      'kindergarten_errored': 'There is an error in your program. Try again!'
    },
    'pt': {
      'kindergarten_passed': 'Seu programa é muito bom!',
      'kindergarten_passed_with_warnings': 'Seu programa é bom, mas pode ser melhorado!',
      'kindergarten_failed': 'Há um erro no seu programa. Tenta de novo!',
      'kindergarten_errored': 'Há um erro no seu programa. Tenta de novo!'
    },
  });

});
