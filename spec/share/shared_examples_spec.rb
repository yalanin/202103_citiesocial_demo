RSpec.shared_examples 'full scope' do
  it '全部範圍' do
    expect(subject.size).to eq(2)
  end
end

RSpec.shared_examples 'line pay error response' do
  [:pay_now, :cancel].each do |method|
    it "should get #{method.to_s} error message" do
      allow(service).to receive(:line_pay_request).and_return(failed_response)
      service.send(method)
      expect(service.send(:success?)).to be false
    end
  end
end