RSpec.describe SimpleCacheLock do
  it "has a version number" do
    expect(SimpleCacheLock::VERSION).not_to be nil
  end

  describe 'configuration' do
    it 'can change redis_urls' do
      expect(described_class.configuration.redis_urls).to be_empty

      urls = ['redis://redis:6379', 'redis://redis:6380']
      expect {
        described_class.configuration.redis_urls = urls
      }.to raise_error
      expect(described_class.configuration.redis_urls).to eq(urls)
    end
  end

  describe '.redlock' do
    before { described_class.configuration.redis_urls = [] }
    it do
      expect(described_class.redlock).to be_a(Redlock::Client)
    end
  end
end
