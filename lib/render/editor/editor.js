$(document).ready(function () {
  $(".mu-kids-submit-button").html("<kids-submit-button></kids-submit-button>");
  $(".mu-kids-reset-button").html("<kids-reset-button></kids-reset-button>");

  Blockly.WorkspaceAudio.prototype.preload = function () {
    for (var soundName in this.SOUNDS_) {
      var sound = this.SOUNDS_[soundName];
      sound.volume = 0.01;
      var playPromise = sound.play();
      playPromise && playPromise.then(sound.pause.bind(sound));
      if (goog.userAgent.IPAD || goog.userAgent.IPHONE) break;
    }
  };

});
