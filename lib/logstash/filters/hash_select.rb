# encoding: utf-8
require "logstash/filters/base"
require "set"

class LogStash::Filters::Hash_select < LogStash::Filters::Base
  config_name "hash_select"

  config :hash_field, :validate => :string, :required => true

  config :include_keys, :validate => :string, :list => true, :default => []
  config :exclude_keys, :validate => :string, :list => true, :default => []

  public
  def register
    # Use faster include method
    @include_keys = Set[*@include_keys]
    @exclude_keys = Set[*@exclude_keys]
  end # def register

  public
  def filter(event)
    field = event.get(@hash_field)
    if field.is_a?(Hash) && (before = field.size).positive?
      field =
        if @include_keys.empty?
          field.reject { |k, _| @exclude_keys.include?(k) } unless @exclude_keys.empty?
        elsif @exclude_keys.empty?
          field.select { |k, _| @include_keys.include?(k) }
        else
          field.select { |k, _| @include_keys.include?(k) && !@exclude_keys.include?(k) }
        end
      event.set(@hash_field, field) if field.size < before
    end

    filter_matched(event)
  end # def filter

end # class LogStash::Filters::Hash_select
