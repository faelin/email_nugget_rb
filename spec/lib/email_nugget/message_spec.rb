require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EmailNugget::Message do
  before do
    @test_message_hash = {
      'data' => 'This is a test message',
      'checksum' => Digest::MD5.hexdigest('This is a test message')
    }
    @message = EmailNugget::Message.new(@test_message_hash)
  end
  
  describe '.new' do
    it "should create an email nugget message from a hash" do
      @message.should be_a_kind_of(EmailNugget::Message)
    end
  end
  
  describe '#checksum' do
    it "should return the checksum of the data" do
      @message.checksum.should == Digest::MD5.hexdigest(@test_message_hash['data'])
    end
    it "should return the checksum of the data if not provided" do
      test_message = EmailNugget::Message.new({'data' => 'test'})
      test_message.checksum.should == Digest::MD5.hexdigest('test')
    end
  end
  
  describe '#data' do
    it "should return the data provided in the message hash" do
      @message.data.should == @test_message_hash['data']
    end
  end

  describe '#data_stream' do
    before do
      @f = File.open(File.dirname(__FILE__) + '/../../fixtures/test1.nugget', 'r')
      @f.readline
      @checksum = @f.readline
      @test_message = EmailNugget::Message.new({'data_stream' => @f, 'checksum' => @checksum})
    end 
    it "should return a StringIO to the data string" do
      @message.data_stream.should be_a_kind_of(StringIO)
    end
    it "should return a FileIO if data stream is provided" do
      @test_message.should be_a_kind_of(EmailNugget::Message)
    end
    it "should return a string calling the data method when provide a data stream" do
      @test_message.data.should be_a_kind_of(String)
    end
    it "should return the argument checksum" do
      @test_message.checksum.should == @checksum
    end
  end
end