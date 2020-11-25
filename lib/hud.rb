require "hud/version"
require 'mote'
require 'ostruct'

module Hud
  
  class Error < StandardError; end

  def self.configuration
    @configuration ||= OpenStruct.new({screens_dir: "./screens"})
  end
  
  def self.configure
    yield(configuration)
  end
  
  class Screen
    include Mote::Helpers 
    def bind(data:); end
    class Controller      
      attr_reader :screen
      def initialize(screen:)
        @screen = screen
      end
      def call
        screen.bind(data:[])
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

      [:body,:title].each do |symbol|
        content = ""
        begin
          content = mote("#{screens_dir(overided: true)}/#{symbol}.mote")
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
      "#{Hud.configuration.screens_dir}/#{self.class.name.gsub("Screen","").downcase}"
    end
  end
end
