require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EmailNugget do
  before do
    @current_time = Time.now
    @test_email_hash = {
      'envelope' => {
        'mail_from' => 'test@test.com',
        'helo' => 'test.com',
        'rcpt_to' => 'test@test.com',
        'ip' => '127.0.0.1',
        'date' => @current_time.to_s,
        'context' => 'inbound',
        'misc' => {'message_id' => '123456'},
      },
      'message' => {
        'data' => 'Test write nugget.',
        'checksum' => Digest::MD5.hexdigest('Test write nugget.')
      }
    }
    @nugget = EmailNugget.new(@test_email_hash) 
  end
  # 
  describe '.new' do
    it "should create a nugget from a hash" do
      @nugget.should be_a_kind_of(EmailNugget)
    end
  end
  
  describe '#envelope' do
    it "should initialize the envelope from the hash" do
      @nugget.envelope.should be_a_kind_of(EmailNugget::Envelope)
    end
  end
  
  describe '#message' do
    it "should initialize the message from the hash" do
      @nugget.message.should be_a_kind_of(EmailNugget::Message)
    end
  end
  
  describe '#id' do
    it "should generate an ID if none is given" do
      @nugget.id.should_not be_nil
    end
    it "should use the ID given in the hash" do
      @test_email_hash['id'] = "asdf"
      test_nugget = EmailNugget.new(@test_email_hash)
      test_nugget.id.should == "asdf"
    end
  end
  
  describe '.write_to()' do
    it "should write the current nugget to the specified file" do
      @nugget.write_to(File.dirname(__FILE__) + '/../fixtures/test2.nugget').should == true
    end
    it "should return false if write failed" do
      @nugget.write_to("/a/a/a/a/bad_path_to.nugget").should == false
    end
  end
  
  describe '.new_from()' do
    it "should create a new nugget from the file path" do
      puts "File: #{File.dirname(__FILE__) + '/../fixtures/test1.nugget'}"
      nugget = EmailNugget.new_from(File.dirname(__FILE__) + '/../fixtures/test1.nugget')
      nugget.should be_a_kind_of(EmailNugget)
    end
    it "should return nil if the nugget file path doesn't exist" do
      nugget = EmailNugget.new_from("/a/a/a/a/bad_path_to.nugget")
      nugget.should be_nil
    end
  end
end
