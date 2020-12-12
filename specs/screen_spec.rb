require "hud"

describe 'Screen' do
  context "#render" do
    it 'to_html' do
        Hud.configure do |config|
           config.screens_dir = "./specs/screens" 
        end 
        class TestScreen < Hud::Screen; end
        content = TestScreen.new.to_html
    
        expect(content).to eql "# Title\n- Body"
      end 
  end
  it 'to_html with overidden body' do
    Hud.configure do |config|
       config.screens_dir = "./specs/screens" 
    end 
    class TestScreen < Hud::Screen; end
    content = TestScreen.new
                .overide(name: :body, value: "Overidden Body")
                .to_html
    expect(content).to eql "# Title\nOveridden Body"
  end 

  it 'to_html with overidden title' do
    Hud.configure do |config|
       config.screens_dir = "./specs/screens" 
    end 
    class TestScreen < Hud::Screen; end
    content = TestScreen.new
                .overide(name: :title, value: "Overidden Title")
                .to_html
    expect(content).to eql "Overidden Title\n- Body"
  end 
  
end