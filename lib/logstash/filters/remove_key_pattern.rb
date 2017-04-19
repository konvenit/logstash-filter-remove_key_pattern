# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "logstash/json"

# Remove key pattern filter. Receives a parent key and an array
# with multiple patterns to remove from it's children
#
# For example, if you have a parent named 'haystack', and you want to
# remove all his children that contains a digit(\d) or 'needle', do this:
# [source, ruby]
#   filter {
#     remove_key_pattern {
#       parent_key => "haystack1"
#       pattern => ["\\d", "needle"]
#       keep_only_ids => "true"
#     }
#   }
#
class LogStash::Filters::RemoveKeyPattern < LogStash::Filters::Base

  config_name "remove_key_pattern"

  # Array of parent keys to remove from
  config :parent_key, :validate => :string, :required => true

  # Array of patterns to remove
  config :pattern, :validate => :array, :required => true

  # Boolean to set if the filter should prevent everything besides the ids that are not in the patterns to pass
  config :keep_only_ids, :validate => :boolean, :required => true, :default => false

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
    remove_pattern(event) unless event.get(@parent_key).nil?
    filter_matched(event)
  end

  private
  def remove_pattern(event)
    hash = {}
    event.get(@parent_key).each do |k, v|
      unless (k =~ @pattern)
        if @keep_only_ids && (k == 'id' or k =~ /.*_id$/)
          hash[k] = v
        elsif !@keep_only_ids
          hash[k] = v
        end
      end
    end
    event.set(@parent_key, hash)
  end
end
