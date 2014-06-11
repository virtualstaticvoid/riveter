require 'spec_helper'
require 'generators/rspec/enquiry/enquiry_generator'

describe Rspec::Generators::EnquiryGenerator, :type => :generator do
  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_enquiry_spec)
    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the spec" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('spec/enquiries/foo_bar_enquiry_spec.rb') }

        it { should exist }
      end
    end
  end
end
