require "hud/version"
require 'mote'
require 'ostruct'

module Hud
  
  class Error < StandardError; end

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
  
  class Screen
    def self.inhereted(subclass)
      controller = Class.new(Hud::Screen::Controller)
      Object.const_set Controller, controller
    end

    def controller(params:)
      Controller.new(screen: self,params: params)
    end

    attr_reader :overides
    include Mote::Helpers 
    def initialize(overides: {})
      @overides = overides
    end 
    def bind(data:); end
    class Controller      
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
    def overide(name:,value:)
      @overides[name] = value
      self
    end

    def render
        mote("#{Hud.configuration.screens_dir}/.defaults/layout.mote",get_params)
    end
  
    def to_s
      render
    end
    

    alias_method :display, :controller
    alias_method :to_json, :controller
    alias_method :to_html, :controller

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

          puts "getting overides ->  #{screens_dir(overided: true)}/#{symbol}.mote"
          content = mote("#{screens_dir(overided: true)}/#{symbol}.mote")
          puts "got overides - ok"
        rescue => exception
          puts "getting default -> #{screens_dir}/#{symbol}.mote"
          content = mote("#{screens_dir}/#{symbol}.mote")
          puts "got defaults - ok"
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
  end
end
