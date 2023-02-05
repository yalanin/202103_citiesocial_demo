RSpec.shared_examples 'full scope' do
  it '全部範圍' do
    expect(subject.size).to eq(2)
  end
end

RSpec.shared_examples 'line pay response' do
  it 'should get error message' do
    allow(line_pay).to receive(:line_pay_request).and_return(failed_response)
    expect(line_pay.line_pay_request[:returnMessage]).to eq('something went wrong')
  end
end