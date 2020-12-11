require "hud/version"
require 'mote'
require 'ostruct'

module Hud
  
  class Error < StandardError; end

  ##################### Config ##################### 

  def self.configuration
    @configuration ||= OpenStruct.new(
      {
        screens_dir: "./screens",
        parts: [:body,:title]
      }
    )
  end

  def self.configure
    yield(configuration)
  end
  

  ##################### Screen ##################### 
  class Screen
    include Mote::Helpers 
    attr_reader :overides
    attr_reader :local
    
    def self.inhereted(subclass)
      controller = Class.new(Hud::Screen::Controller)
      Object.const_set Controller, controller
    end

    def self.render
      new.display
    end
    def self.display
      render
    end

  
    def controller(params:{})
      Controller.new(screen: self,params: params)
    end

    def initialize(overides: {},local: {})
      @overides = overides
      @local = local
    end 
    
    def bind(data:); end

    ##################### contoller ##################### 

    class Controller      
      attr_reader :screen
      def initialize(screen:,params:,data:[])
        @screen = screen
        @params = params
        @data = []
      end
      def call
        screen.bind(data: @data)
        screen.render
      end
      def to_s
        call
      end
    end
    
    def overide(name:,value:,scope: :local)
      @local[name] = value if scope == :local
      @overides[name] = value if scope == :global
      self
    end
    
    def to_s
      render
    end
    
    def render
        mote("#{Hud.configuration.screens_dir}/.defaults/layout.mote",get_params)
    end
  
    private

    def get_params
      params = {}
      Hud.configuration.parts.each do |symbol|
        content = ""
        begin
          if overides.has_key? symbol
            content = overides[symbol] 
            next
          end
          content = mote("#{screens_dir(overided: true)}/#{symbol}.mote",local)
        rescue => exception
          content = mote("#{screens_dir}/#{symbol}.mote")        
        ensure
          params[symbol] = content
        end
      end
      params
    end
    def screens_dir(overided: false)
      return "#{Hud.configuration.screens_dir}/.defaults" unless overided
      "#{Hud.configuration.screens_dir}/#{self.class.name.gsub(/\w*::/,"").gsub("Screen","").downcase}"
    end
 
    alias_method :display, :controller
    alias_method :to_json, :controller
    alias_method :to_html, :controller
  end
end
