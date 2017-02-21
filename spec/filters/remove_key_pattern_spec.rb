# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/remove_key_pattern"

describe LogStash::Filters::RemoveKeyPattern do
  describe "remove a pattern from parent's children" do
    let(:config) do <<-CONFIG
      filter {
        remove_key_pattern {
          parent => "haystack",
          patten => ["needle", "\\d"]
        }
      }
    CONFIG
    end

    hash = {
      "hello" => { "whoa" => [ 1, 2, 3, 4 ] },
      "haystack" => {
        "key1" => ["value1", "value2", "value3"],
        "key_two" => ["value1", "value2", "value3"],
        "key4" => ["value1", "value2", "value3"],
        "key_four" => ["value1", "value2", "value3"],
        "needle" => ["value1", "value2", "value3"],
      }
    }



    sample(JSON.dump(hash)) do
      expect(subject).to include("message")
      expect(subject['message']).to eq('Hello World')
    end
  end
end
