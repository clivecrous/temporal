module Temporal
  class Parser
    @@literals = {}

    def self.add_literal literal, &block
      @@literals[ literal ] = block
    end

    def self.match? string
      to_match = string.downcase.strip
      @@literals.keys.each do |key|
        return true if to_match =~ key
      end
      return false
    end

    def self.parse string
      @@literals.keys.each do |key|
        match = string.match(key)
        next unless match
        result = []
        result << parse(match.pre_match) if match.pre_match.strip.size > 0
        result << @@literals[key].call
        result << parse(match.post_match) if match.post_match.strip.size > 0
        result.flatten!
        if result.empty?
          result = nil
        else
          result = result.pop if result.size == 1
        end
        return result
      end
      string
    end

  end
end
