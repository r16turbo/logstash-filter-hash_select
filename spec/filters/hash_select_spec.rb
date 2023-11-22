# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/hash_select"

describe LogStash::Filters::Hash_select do

  subject { LogStash::Filters::Hash_select.new(config) }

  let(:config) { {} }
  let(:event) {
    LogStash::Event.new(
      "@timestamp" => "2020-01-01T00:00:00Z",
      "kubernetes" => { "labels" => { "app" => "dummy" } },
      "prometheus" => {
        "labels" => {
          "foo" => "bar", "abc" => "xyz",
          "bar" => "foo", "xyz" => "abc",
          "test" => "123"
        },
        "metrics" => { "message" => "Hello World!" }
      }
    )
  }

  describe "hash_field" do

    let(:config) { { "hash_field" => "labels" } }

    before do
      subject.register
      subject.filter(event)
    end

    it "hash_field check" do
      expect(event.get("labels")).to be_nil
      expect(event.get("[prometheus][labels]")).to eq({
        "foo" => "bar", "abc" => "xyz",
        "bar" => "foo", "xyz" => "abc",
        "test" => "123"
      })
    end

  end

  describe "include_keys" do

    let(:config) do
    {
      "hash_field" => "[prometheus][labels]",
      "include_keys" => [ "foo", "abc", "test" ]
    }
    end

    before do
      subject.register
      subject.filter(event)
    end

    it "include_keys filter" do
      expect(event.get("[prometheus][labels]")).to eq({
        "abc"=>"xyz","foo"=>"bar", "test" => "123"
      })
    end

  end

  describe "include_keys" do

    let(:config) do
    {
      "hash_field" => "[prometheus][labels]",
      "include_keys" => [ "foo", "abc", "test" ]
    }
    end

    before do
      subject.register
      subject.filter(event)
    end

    it "include_keys filter" do
      expect(event.get("[prometheus][labels]")).to eq({
        "abc"=>"xyz","foo"=>"bar", "test" => "123"
      })
    end

  end

  describe "exclude_keys" do

    let(:config) do
    {
      "hash_field" => "[prometheus][labels]",
      "exclude_keys" => [ "bar", "xyz", "test" ]
    }
    end

    before do
      subject.register
      subject.filter(event)
    end

    it "exclude_keys filter" do
      expect(event.get("[prometheus][labels]")).to eq({
        "foo" => "bar", "abc" => "xyz"
      })
    end

  end

  describe "include_keys and exclude_keys" do

    let(:config) do
    {
      "hash_field" => "[prometheus][labels]",
      "include_keys" => [ "foo", "abc", "test" ],
      "exclude_keys" => [ "bar", "xyz", "test" ]
    }
    end

    before do
      subject.register
      subject.filter(event)
    end

    it "include_keys and exclude_keys filter" do
      expect(event.get("[prometheus][labels]")).to eq({
        "abc" => "xyz", "foo" => "bar"
      })
    end

  end

end
