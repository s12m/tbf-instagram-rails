FactoryBot.define do
  factory :post do
    image { fixture_file_upload('spec/fixtures/test.jpg') }
    body { 'Post body' }
  end
end
