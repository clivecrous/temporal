# FIXME This code is still only in "proof of concept" form and requires a
# complete refactor
module Temporal
  class Parser
    class << self
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

        # XXX
        string.gsub!(/the third (\w+)/,'3 \1s')

        if string =~ /after|from/
          portions = string.split(/after|beyond|from/).map{|n|n.strip}
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

        if string =~ /beyond/
          portions = string.split(/beyond/).map{|n|n.strip}
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
        result = Time.now if string =~ /now/
        result ||= string

        #puts "#{options[:travel].to_s} >> #{result}"

        return result if result.class == Time
        if result.class == Temporal::Adjuster
          return options[:context] + result if options[:travel] == :future
          return options[:context] - result if options[:travel] == :past
        end
        throw "Unable to parse"

      end
    end
  end
end
