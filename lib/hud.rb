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
    include Mote::Helpers 
    def bind(data:); end
    class Controller      
      attr_reader :screen,:params
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
        params = get_params
        yield(params) if block_given?
        mote("#{Hud.configuration.screens_dir}/.defaults/layout.mote",params)
    end

    def to_s
      render
    end
    
    private

    def get_params
      params = {}

      Hud.configuration.parts.each do |symbol|
        content = ""
        begin
          puts "getting overides from  #{screens_dir(overided: true)}/#{symbol}.mote"
          content = mote("#{screens_dir(overided: true)}/#{symbol}.mote")
          puts "got overides - ok"
        rescue => exception
          puts "getting default from #{screens_dir}/#{symbol}.mote"
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
      "#{Hud.configuration.screens_dir}/#{self.class.name.gsub("Screen","").downcase}"
    end
  end
end
