class EmailNugget
  class Envelope
    attr_accessor :ip, :helo, :mail_from, :rcpt_to, :date, :context, :misc
    
    def initialize(args = {})
      self.ip = args[:ip] || args['ip'] || ""
      self.helo = args[:helo] || args['helo'] || ""
      self.mail_from = args[:mail_from] || args['mail_from'] || ""
      self.rcpt_to = args[:rcpt_to] || args['rcpt_to'] || []
      self.date = args[:date] || args['date'] || ""
      self.context = args[:context] || args['context'] || ""
      self.misc = args[:misc] || args['misc'] || {}
      self.ensure_fields
    end
    
    def ensure_fields
      if !self.rcpt_to.is_a?(Array)
        self.rcpt_to = [self.rcpt_to]
      end

      if !self.misc.is_a?(Hash)
        if self.misc.is_a?(Array)
          temp = {}
          self.misc.each do |m|
            temp[m] = 1 
          end
          self.misc = temp
        elsif self.misc.is_a?(String) || self.misc.is_a?(Integer)
          temp = {self.misc => 1}
          self.misc = temp
        else
          self.misc = {}
        end
      end
    end
  end
end
