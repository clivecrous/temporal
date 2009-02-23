module Temporal
  class Parser

    add_literal( /(^|\W)noe(\W|$)/i ) do
      Time.now
    end

    add_literal( /(^|\W)vandag(\W|$)/i ) do
      today_start = Time.parse(Time.now.strftime("%Y-%m-%d"))
      today_start...today_start+1.day
    end

    add_literal( /(^|\W)gister(\W|$)/i ) do
      yesterday_start = Time.parse((Time.now-1.day).strftime("%Y-%m-%d"))
      yesterday_start...yesterday_start+1.day
    end

    add_literal( /(^|\W)more(\W|$)/i ) do
      tomorrow_start = Time.parse((Time.now+1.day).strftime("%Y-%m-%d"))
      tomorrow_start...tomorrow_start+1.day
    end

  end
end
