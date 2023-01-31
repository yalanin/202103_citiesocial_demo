RSpec.shared_examples 'full scope' do
  it '全部範圍' do
    expect(subject.size).to eq(2)
  end
end