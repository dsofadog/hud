require "hud"

describe 'Screen' do
  context "override using a file" do
    it 'to_html defaults' do
      Hud.configure do |config|
         config.screens_dir = "./specs/overridenscreens-local" 
      end 
      class TestScreen < Hud::Screen; end
      content = TestScreen.new
                  .overide(name: :state, value: "local")
                  .to_html
  
      expect(content).to eql "# Title\n- Body (local)\n"
    end 

  end

  context "override using a file" do
    it 'to_html defaults' do
      Hud.configure do |config|
         config.screens_dir = "./specs/overridenscreens" 
      end 
      class TestScreen < Hud::Screen; end
      content = TestScreen.new.to_html
  
      expect(content).to eql "# Title\n- Body"
    end 
    it 'to_html for index' do
      Hud.configure do |config|
         config.screens_dir = "./specs/overridenscreens" 
      end 
      class IndexScreen < Hud::Screen; end
      content = IndexScreen.new.to_html
  
      expect(content).to eql "# Title (overidden)\n- Body (overidden)"
    end 
   
  end
  
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