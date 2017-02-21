# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "logstash/json"

# Remove key pattern filter. Receives a parent key and an array
# with multiple patterns to remove from it's children
#
# For example, if you have a parent named 'haystack', and you want to
# remove all his children that contains a digit(\d) or 'needle', do this:
#
# filter {
#    remove_key_pattern{
#     parent => "haystack",
#     pattern => ["\\d", "needle"]
#   }
# }
#
class LogStash::Filters::RemoveKeyPattern < LogStash::Filters::Base

  config_name "remove_key_pattern"

  # Parent key to remove from
  config :parent, :validate => :string, :required => true

  # Array of patterns
  config :pattern, :validate => :array, :required => true

  public
  def register
    begin
      @pattern = Regexp.new(@pattern.join('|'))
    rescue
      @logger.error("One or more keys are invalid", :pattern => @pattern.join(', '))
      raise "Bad pattern, aborting"
    end
  end

  public
  def filter(event)
    remove_pattern(event)

    filter_matched(event)
  end

  private
  def remove_pattern(event)
    hash = {}
    event.get(@parent).each do |k, v|
      if (k == 'id' or k =~ /.*_id$/) && !(k =~ @pattern)
        hash[k] = v
      end
    end
    event.set("#{@parent}_json", LogStash::Json.dump(event.get(@parent)))
    event.set(@parent, hash)
  end
end
