require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EmailNugget::Envelope do
  before do
    @current_time = Time.now
    @test_envelope_hash = {
      'ip' => '127.0.0.1',
      'helo' => 'localhost.localdomain',
      'mail_from' => 'root@localhost',
      'rcpt_to' => 'root@localhost',
      'date' => @current_time.to_s,
      'context' => 'inbound'
    }
    @envelope = EmailNugget::Envelope.new(@test_envelope_hash)
  end

  describe '.new' do
    it "should create an email nugget envelope from a hash" do
      @envelope.should be_a_kind_of(EmailNugget::Envelope)
    end
    it "should return empty string for fields not set in initialize" do
      with_nil_params = {
        'ip' => '127.0.0.1',
        'rcpt_to' => 'root@localhost'
      }
      test_envelope = EmailNugget::Envelope.new(with_nil_params)
      test_envelope.mail_from.should == ""
    end
  end

  describe '#ip' do
    it "should return the sender IP address" do
      @envelope.ip.should == @test_envelope_hash['ip']
    end
  end

  describe '#helo' do
    it "should return the helo host" do
      @envelope.helo.should == @test_envelope_hash['helo']
    end
  end

  describe '#mail_from' do
    it "should return the mail_from" do
      @envelope.mail_from.should == @test_envelope_hash['mail_from']
    end
  end
  
  describe '#rcpt_to' do
    it "should return the rcpt_to array" do
      @envelope.rcpt_to.should be_a_kind_of(Array)
    end
    it "should contain the first rcpt_to in the first array item" do
      @envelope.rcpt_to[0].should == @test_envelope_hash['rcpt_to']
    end
  end
  
  describe '#date' do
    it "should return the date" do
      @envelope.date.should == @test_envelope_hash['date']
    end
  end
end