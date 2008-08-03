# FIXME This code is still only in "proof of concept" form and requires a
# complete refactor
module Temporal
  class Parser

    @@literals = {
        'now' => proc{Time.now},
        'today' => proc{today_start=Time.parse(Time.now.strftime("%Y-%m-%d"));today_start...today_start+1.day},
        'yesterday' => proc{today_start=Time.parse((Time.now-1.day).strftime("%Y-%m-%d"));today_start...today_start+1.day},
        'tomorrow' => proc{today_start=Time.parse((Time.now+1.day).strftime("%Y-%m-%d"));today_start...today_start+1.day},
      }

    class << self

      public

      def literals
        @@literals
      end

      private

      def cleanup string
        string.strip!
        string.downcase!
        string.gsub!(/\s+/,' ')
        string.gsub!(/[^a-z 0-9]/,'')
      end

      def text_numbers string
        string.gsub!(/one/,'1')
        string.gsub!(/two/,'2')
        string.gsub!(/three/,'3')
        string.gsub!(/four/,'4')
        string.gsub!(/five/,'5')
        string.gsub!(/six/,'6')
        string.gsub!(/seven/,'7')
        string.gsub!(/eight/,'8')
        string.gsub!(/nine/,'9')
        string.gsub!(/ten/,'10')
        string.gsub!(/eleven/,'11')
        string.gsub!(/twelve/,'12')
        string.gsub!(/thirteen/,'13')
      end

      public

      def parse string, options={}

        options = {
          :clean => true,
          :travel => :current,
          :context => Time.now
        }.merge( options )

        if options[:clean]
          cleanup string

          options[:clean] = false
        end

        text_numbers string

        string.gsub!(/((?:year|month|week|day|hour|minute|second)s?)\s+and\s+([0-9]+)/,'\1 & \2')

        # XXX
        string.gsub!(/the third (\w+)/,'3 \1s')

        phrases = string.split(/but|and|because/).map{|n|n.strip.gsub('&','and')}

        if phrases.size > 1
          results = []
          phrases.each do |clause|
            results << parse(clause,options)
          end
          return results
        else
          string = phrases[0]
        end

        if string =~ /is|was/
          portions = string.split(/is|was/).map{|n|n.strip}
          throw "too many is" if portions.size > 2
          portions.map!{|n|parse(n,options)}
          return Hash[ *portions ]
        end

        if string =~ /after|from/
          portions = string.split(/after|from/).map{|n|n.strip}
          context = parse( portions.pop, options )
          while not portions.empty?
            context = parse( portions.pop, options.merge({:context=>context,:travel=>:future}) )
          end
          return context
        end

        if string =~ /prior to|before/
          portions = string.split(/prior to|before/).map{|n|n.strip}
          context = parse( portions.pop, options )
          while not portions.empty?
            context = parse( portions.pop, options.merge({:context=>context,:travel=>:past}) )
          end
          return context
        end

        if string =~ /beyond|and/
          portions = string.split(/beyond|and/).map{|n|n.strip}
          context = parse( portions.pop, options )
          while not portions.empty?
            context = parse( portions.pop, options.merge({:context=>context}) )
          end
          return context
        end

        #puts "(#{options[:context]},#{options[:travel].to_s})>> #{string}"

        result = nil
        temporal_adjustment = Temporal::Adjuster.parse( string )
        result ||= temporal_adjustment

        if @@literals.has_key?( string )
          result = 
            if @@literals[string].class == Proc
              @@literals[string].call 
            else
              @@literals[string]
            end
        end

        unless result
          result = Time.parse( string, Time.at(0) )
          result = nil if result == Time.at(0)
        end

        result ||= string

        #puts "#{options[:travel].to_s} >> #{result}"

        return result if result.class == Time
        return result if result.class == Range and result.first.class == Time and result.last.class == Time
        if result.class == Temporal::Adjuster
          return options[:context] + result if options[:travel] == :future
          return options[:context] - result if options[:travel] == :past
        end

        result

      end
    end
  end
end
