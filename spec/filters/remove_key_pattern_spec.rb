# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/remove_key_pattern"

describe LogStash::Filters::RemoveKeyPattern do

  describe "remove a pattern from parent's children" do
    config <<-CONFIG
      filter {
        remove_key_pattern {
          parent => "haystack"
          pattern => ["needle", "\\d"]
        }
      }
    CONFIG

    hash = {
      "hello" => { "numbers" => [ 1, 2, 3, 4 ] },
      "haystack" => {
        "key1_id" => ["value1", "value2", "value3"],
        "id" => ["value1", "value2", "value3"],
        "key4_id" => ["value1", "value2", "value3"],
        "key_four_id" => ["value1", "value2", "value3"],
        "needle" => ["value1", "value2", "value3"],
      }
    }

    sample(hash) do
      insist { subject.get("hello") }.include?("numbers")
      insist { subject.get("haystack") }.include?("id")
      insist { subject.get("haystack") }.include?("key_four_id")
      reject { subject.get("haystack") }.include?("key4_id")
    end
  end

end
