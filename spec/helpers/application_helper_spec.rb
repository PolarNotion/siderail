require 'rails_helper'

describe ApplicationHelper do
  describe "#format_date" do
    it 'returns a properly formatted date' do
      test_date = 'Mon, 22 Jul 2019 01:28:48 UTC +00:00'.to_date
      expect(helper.format_date(test_date)).to eq("Jul 22, 2019")
    end
  end

  describe "#format_time" do
    it 'returns a properly formatted date' do
      test_date = 'Mon, 22 Jul 2019 01:28:48 UTC +00:00'.to_date
      expect(helper.format_time(test_date)).to eq("12 am")
    end
  end

  describe "#format_date_range" do
    it 'returns a properly formatted range when same day' do
      test_date_1 = 'Mon, 22 Jul 2019 01:28:48 UTC +00:00'.to_date
      test_date_2 = 'Mon, 22 Jul 2019 02:28:48 UTC +00:00'.to_date
      expect(helper.format_date_range(test_date_1, test_date_2)).to eq("Jul 22, 2019")
    end
    it 'returns a properly formatted range when different days' do
      test_date_1 = 'Mon, 22 Jul 2019 01:28:48 UTC +00:00'.to_date
      test_date_2 = 'Mon, 23 Jul 2019 01:28:48 UTC +00:00'.to_date
      expect(helper.format_date_range(test_date_1, test_date_2)).to eq("Jul 22 - Jul 23, 2019")
    end

    it 'returns a properly formatted range when different years' do
      test_date_1 = 'Mon, 22 Jul 2019 01:28:48 UTC +00:00'.to_date
      test_date_2 = 'Mon, 23 Jul 2020 01:28:48 UTC +00:00'.to_date
      expect(helper.format_date_range(test_date_1, test_date_2)).to eq("Jul 22, 2019 - Jul 23, 2020")
    end
  end
end
