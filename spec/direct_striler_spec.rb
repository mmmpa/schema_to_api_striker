require 'rspec'
require './lib/direct_striker'
require 'pp'

describe DirectStriker do
  it { DirectStriker }
  it { DirectStriker.new(Pathname.new(__dir__).join('../schema/qiita_api_schema.json')) }


  describe do
    before :all do
      @api = DirectStriker.new(Pathname.new(__dir__).join('../schema/qiita_api_schema.json'))
    end

    it { pp @api.list_items }
  end
end