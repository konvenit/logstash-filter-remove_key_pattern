# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/remove_key_pattern"

describe LogStash::Filters::RemoveKeyPattern do
  describe "Set to Hello World" do
    let(:config) do <<-CONFIG
      filter {
        remove_key_pattern {
          message => "Hello World"
        }
      }
    CONFIG
    end

    sample("message" => "some text") do
      expect(subject).to include("message")
      expect(subject['message']).to eq('Hello World')
    end
  end
end
