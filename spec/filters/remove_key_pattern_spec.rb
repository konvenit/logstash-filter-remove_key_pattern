# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/remove_key_pattern"

describe LogStash::Filters::RemoveKeyPattern do

  describe "remove a pattern from parent keys keeping only ids" do
    config <<-CONFIG
      filter {
        remove_key_pattern {
          parent_keys => ["haystack1", "haystack2"]
          pattern => ["needle", "\\d"]
          keep_only_ids => "true"
        }
      }
    CONFIG

    hash = {
      "hello" => {
        "numbers" => ["one", "two", "three"],
        "47" => ["2", "3", "7"],
      },
      "haystack1" => {
        "key1_id" => ["value1", "value2", "value3"],
        "id" => ["value1", "value2", "value3"],
        "key4_id" => ["value1", "value2", "value3"],
        "key_four_id" => ["value1", "value2", "value3"],
        "needle" => ["value1", "value2", "value3"],
      },
      "haystack2" => {
        "key_one_id" => ["value1", "value2", "value3"],
        "id" => ["value1", "value2", "value3"],
        "key4_id" => ["value1", "value2", "value3"],
        "key" => ["value1", "value2", "value3"],
        "foobar" => ["value1", "value2", "value3"],
      }
    }

    sample(hash) do
      insist { subject.get("hello") }.include?("numbers")
      insist { subject.get("haystack1") }.include?("id")
      insist { subject.get("haystack1") }.include?("key_four_id")
      reject { subject.get("haystack1") }.include?("key4_id")
      reject { subject.get("haystack2") }.include?("needle")
      insist { subject.get("haystack2") }.include?("key_one_id")
      reject { subject.get("haystack2") }.include?("key4_id")
      reject { subject.get("haystack2") }.include?("key")
      reject { subject.get("haystack2") }.include?("foobar")
    end
  end

  describe "remove a pattern from parent keys without keeping only ids" do
    config <<-CONFIG
      filter {
        remove_key_pattern {
          parent_keys => ["haystack", "haystack2"]
          pattern => ["needle", "\\d"]
          keep_only_ids => "false"
        }
      }
    CONFIG

    hash = {
      "hello" => {
        "numbers" => ["one", "two", "three"],
        "47" => ["2", "3", "7"],
      },
      "haystack" => {
        "key1_id" => ["value1", "value2", "value3"],
        "id" => ["value1", "value2", "value3"],
        "key4_id" => ["value1", "value2", "value3"],
        "key_four_id" => ["value1", "value2", "value3"],
        "needle" => ["value1", "value2", "value3"],
      },
      "haystack2" => {
        "key_one_id" => ["value1", "value2", "value3"],
        "id" => ["value1", "value2", "value3"],
        "key4_id" => ["value1", "value2", "value3"],
        "key" => ["value1", "value2", "value3"],
        "foobar" => ["value1", "value2", "value3"],
      }
    }

    sample(hash) do
      insist { subject.get("haystack") }.include?("id")
      insist { subject.get("haystack") }.include?("key_four_id")
      reject { subject.get("haystack") }.include?("key4_id")
      reject { subject.get("haystack2") }.include?("needle")
      insist { subject.get("haystack2") }.include?("key_one_id")
      reject { subject.get("haystack2") }.include?("key4_id")
      insist { subject.get("haystack2") }.include?("key")
      insist { subject.get("haystack2") }.include?("foobar")
    end
  end

  describe "try to remove a pattern from unexisting parent keys" do
    config <<-CONFIG
      filter {
        remove_key_pattern {
          parent_keys => ["h2"]
          pattern => ["needle", "\\d"]
          keep_only_ids => "true"
        }
      }
    CONFIG

    hash = {
      "hello" => {
        "numbers" => ["one", "two", "three"],
        "47" => ["2", "3", "7"],
      },
      "haystack" => {
        "key1_id" => ["value1", "value2", "value3"],
        "id" => ["value1", "value2", "value3"],
        "key4_id" => ["value1", "value2", "value3"],
        "key_four_id" => ["value1", "value2", "value3"],
        "needle" => ["value1", "value2", "value3"],
      },
      "haystack2" => {
        "key_one_id" => ["value1", "value2", "value3"],
        "id" => ["value1", "value2", "value3"],
        "key4_id" => ["value1", "value2", "value3"],
        "key" => ["value1", "value2", "value3"],
        "foobar" => ["value1", "value2", "value3"],
      }
    }

    sample(hash) do
      insist { subject.get("hello") }.include?("numbers")
      insist { subject.get("haystack") }.include?("id")
      insist { subject.get("haystack") }.include?("key_four_id")
      insist { subject.get("haystack") }.include?("key4_id")
      insist { subject.get("haystack2") }.include?("key_one_id")
      insist { subject.get("haystack2") }.include?("key4_id")
      insist { subject.get("haystack2") }.include?("key")
      insist { subject.get("haystack2") }.include?("foobar")
    end
  end


end
