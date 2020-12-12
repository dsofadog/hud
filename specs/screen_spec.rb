require "hud"

describe 'Screen' do
  it 'display' do
    Hud.configure do |config|
       config.screens_dir = "./specs/screens" 
    end 
    class TestScreen < Hud::Screen; end
    content = TestScreen.new.to_html

    expect(content).to eql "# Title\n- Body"
  end
end