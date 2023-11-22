# encoding: utf-8
require "logstash/filters/base"

# This hash_select filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an hash_select.
class LogStash::Filters::Hash_select < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   hash_select {
  #     message => "My message..."
  #   }
  # }
  #
  config_name "hash_select"

  # Replace the message with this value.
  config :message, :validate => :string, :default => "Hello World!"


  public
  def register
    # Add instance variables
  end # def register

  public
  def filter(event)

    if @message
      # Replace the event message with our message as configured in the
      # config file.
      event.set("message", @message)
    end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Hash_select
