require 'digest/md5'

class EmailNugget
  class Message
    attr_accessor :arg_checksum, :arg_data, :arg_data_stream
    
    def initialize(args = {})
      self.arg_checksum = args[:checksum] || args['checksum']
      self.arg_data = args[:data] || args['data']
      self.arg_data_stream =  args[:data_stream] || args['data_stream']
    end
    
    def data_stream
      if self.arg_data_stream
        self.arg_data_stream
      else 
        StringIO.new(self.data)
      end
    end

    def data
      if self.arg_data.nil?
        self.arg_data = self.arg_data_stream.read
      end
      self.arg_data
    end

    def checksum  
      if self.arg_checksum.nil?
        Digest::MD5.hexdigest(self.data)
      else
        self.arg_checksum
      end
    end
  end
end
