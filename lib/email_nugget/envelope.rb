class EmailNugget
  class Envelope
    attr_accessor :ip, :helo, :mail_from, :rcpt_to, :date, :context
    
    def initialize(args = {})
      @ip = args[:ip] || args['ip'] || ""
      @helo = args[:helo] || args['helo'] || ""
      @mail_from = args[:mail_from] || args['mail_from'] || ""
      @a_rcpt_to = args[:rcpt_to] || args['rcpt_to'] || []
      @a_date = args[:date] || args['date'] || ""
      @context = args[:context] || args['context'] || ""
      self.rcpt_to = []
      ensure_fields
    end
    
    def ensure_fields
      self.ip = @ip.gsub(/\n/, "")
      self.helo = @helo.gsub(/\n/, "")
      self.mail_from = @mail_from.gsub(/\n/, "")
      self.date = @a_date.gsub(/\n/, "")
      self.context = @context.gsub(/\n/, "")
      if !@a_rcpt_to.is_a?(Array)
        @a_rcpt_to = [@a_rcpt_to]
      end
      @a_rcpt_to.length.times do |i|
        self.rcpt_to.push(@a_rcpt_to[i].gsub(/\n/, ""))
      end
    end
  end
end
