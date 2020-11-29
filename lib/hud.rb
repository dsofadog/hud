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
    attr_reader :overides
    include Mote::Helpers
    def initialize(overides: {})
      @overides = overides
    end 
    def bind(data:); end
    class Controller      
      attr_reader :screen,:params,:overides
      def initialize(screen:,params:)
        @screen = screen
        @params = params
      end
      def call(data: [])
        screen.bind(data: data)
        screen.render
      end
    end

    def render
        params = !param_overides.values.empty? ? param_overides : get_params
        mote("#{Hud.configuration.screens_dir}/.defaults/layout.mote",params)
    end
  
    def to_s
      render
    end
    
    private

    def param_overides
      data = {}
      Hud.configuration.parts.each do |symbol|
        data[symbol] = @overides[symbol] if @overides.has_key? symbol
      end
      data
    end

    def get_params
      params = {}

      Hud.configuration.parts.each do |symbol|
        content = ""
        begin
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
