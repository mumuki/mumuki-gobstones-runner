describe 'Gobstones board' do
  describe 'required assets' do
    it { expect(File.exist? Gobstones::Board.assets_path_for('htmls/gs-board.html')).to be true }
    it { expect(File.exist? Gobstones::Board.assets_path_for('htmls/vendor/polymer.html')).to be true }
    it { expect(File.exist? Gobstones::Board.assets_path_for('htmls/vendor/polymer-mini.html')).to be true }
    it { expect(File.exist? Gobstones::Board.assets_path_for('htmls/vendor/polymer-micro.html')).to be true }
    it { expect(File.exist? Gobstones::Board.assets_path_for('javascripts/vendor/webcomponents.min.js')).to be true }
  end
end
