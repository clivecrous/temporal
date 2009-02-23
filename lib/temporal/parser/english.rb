module Temporal
  class Parser

    add_literal( /(^|\W)now(\W|$)/i ) do
      Time.now
    end

    add_literal( /(^|\W)today(\W|$)/i ) do
      today_start = Time.parse(Time.now.strftime("%Y-%m-%d"))
      today_start...today_start+1.day
    end

    add_literal( /(^|\W)yesterday(\W|$)/i ) do
      yesterday_start = Time.parse((Time.now-1.day).strftime("%Y-%m-%d"))
      yesterday_start...yesterday_start+1.day
    end

    add_literal( /(^|\W)tomorrow(\W|$)/i ) do
      tomorrow_start = Time.parse((Time.now+1.day).strftime("%Y-%m-%d"))
      tomorrow_start...tomorrow_start+1.day
    end

  end
end
