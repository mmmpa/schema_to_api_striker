require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'pp'
require 'rest_client'
require 'uri'

class DirectStriker
  def initialize(file)
    @schema = JSON.parse(File.read(file)).deep_symbolize_keys!
    @endpoint = {}
    parse_links!
  end

  def parse_links!(schema = @schema)
    schema.each do |k, v|
      if k == :links
        # trace link
        v.each do |link|
          @endpoint[link[:title].to_sym] ||= {}
          @endpoint[link[:title].to_sym][:href] = link[:href]
          @endpoint[link[:title].to_sym][:method] = link[:method].downcase.to_sym
        end
      end

      parse_links!(v) if Hash === v
    end
  end

  def method_missing(name, params = {}, options = {})
    here = @endpoint[name.to_sym]
    super unless here

    if here[:method] == :get
      uri = URI(here[:href])
      uri.query = params.to_param
      RestClient.get(uri.to_s, options)
    else
      RestClient.send(here[:method], params, options)
    end
  end
end