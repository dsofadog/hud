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

    def initialize(overides: {})
      @overides = overides  
    end 
    
    def overide(name:,value:,scope: :global)
      @overides[name] = value  if scope == :global
      self
    end
    
    def render
      mote("#{Hud.configuration.screens_dir}/layout.mote",get_params)
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
          content = mote("#{screens_dir(overided: true)}/#{symbol}.mote",{})
        rescue => exception
          content = mote("#{screens_dir}/#{symbol}.mote")        
        ensure
          params[symbol] = content
        end
      end
      params
    end

    def screens_dir(overided: false)
      return "#{Hud.configuration.screens_dir}" unless overided
      "#{Hud.configuration.screens_dir}/#{self.class.name.gsub(/\w*::/,"").gsub("Screen","").downcase}"
    end

    alias_method :to_json, :render
    alias_method :to_html, :render
  end
end
