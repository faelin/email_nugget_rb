require 'uuid'
require 'json'

class EmailNugget
  autoload "Envelope", "email_nugget/envelope"
  autoload "Message", "email_nugget/message"

  attr_accessor :id, :envelope, :message

  # Initialize a new email nugget.
  def initialize(args = {})
    self.envelope = EmailNugget::Envelope.new(args[:envelope] || args['envelope'])
    self.message = EmailNugget::Message.new(args[:message] || args['message'])
    self.id = args[:id] || args['id'] || generate_id
  end
  
  # Generate a new UUID
  def generate_id
    UUID.new.generate
  end
  
  def to_hash
    {
      :ip => self.envelope.ip,
      :helo => self.envelope.helo,
      :mail_from => self.envelope.mail_from,
      :rcpt_to => self.envelope.rcpt_to,
      :date => self.envelope.date,
      :context => self.envelope.context
    }
  end
  
  # Save the current nugget to the specified file.
  def write_to(file_path)
    # Catch any errors opening or writing to the file.
    begin
      nugget_file = File.open(file_path, "w")
      # Save the envelope as JSON in the first line.
      nugget_file.syswrite(to_hash.to_json + "\n")
      # Save the checksum in the second line.
      nugget_file.syswrite(self.message.checksum + "\n")
      # Save the message contents after the second line.
      nugget_file.syswrite(self.message.data + "\n")
    rescue => e
      # Unable to save email nugget to file_path
      #puts "Error saving email nugget to #{file_path}: #{e.to_s}"
      return false
    end
    # Success
    return true
  end
  
  class << self
    # Create a new email nugget from the specified file path.
    def new_from(file_path)
      # Catch any errors opening or reading from the file.
      begin
        nugget_file = File.open(file_path, 'rb')
        # Envelope is the first line.
        envelope = JSON.parse(nugget_file.readline.chomp)
        # Checksum is the second line.
        checksum = nugget_file.readline.chomp
        return EmailNugget.new({'envelope' => envelope, 'message' => {'data_stream' => nugget_file}})
      rescue => e
        # Unable to open or read nugget file.
        #puts "Error creating email nugget from #{file_path}: #{e.to_s}"
        return nil
      end
    end
  end
end