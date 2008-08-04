module Temporal
  class Node
    @@literals = {
        /(^|\W)now(\W|$)/i => proc{Time.now},
        /(^|\W)today(\W|$)/i => proc{today_start=Time.parse(Time.now.strftime("%Y-%m-%d"));today_start...today_start+1.day},
        /(^|\W)yesterday(\W|$)/i => proc{today_start=Time.parse((Time.now-1.day).strftime("%Y-%m-%d"));today_start...today_start+1.day},
        /(^|\W)tomorrow(\W|$)/i => proc{today_start=Time.parse((Time.now+1.day).strftime("%Y-%m-%d"));today_start...today_start+1.day},
    }

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
