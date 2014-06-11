require 'spec_helper'
require 'generators/riveter/enquiry/enquiry_generator'

describe Riveter::Generators::EnquiryGenerator, :type => :generator do
  before do
    FileUtils.mkdir_p(file('config/locales'))
    File.open(file('config/routes.rb'), 'w') {|f| f.write "TestApp::Application.routes.draw do\nend\n" }
  end

  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_enquiry_file)
    expect(gen).to receive(:create_module_file)

    # hooks
    expect(gen).to receive(:_invoke_from_option_enquiry_controller)
    expect(gen).to receive(:_invoke_from_option_query)
    expect(gen).to receive(:_invoke_from_option_query_filter)
    expect(gen).to receive(:_invoke_from_option_test_framework)

    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the enquiry" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('app/enquiries/foo_bar_enquiry.rb') }

        it { should exist }
        it { should contain('class FooBarEnquiry') }
      end

      describe "with attributes" do
        before do
          run_generator %w(foo_bar name:string:required active:boolean other)
        end

        subject { file('app/enquiries/foo_bar_enquiry.rb') }

        it { should exist }
        it { should contain('class FooBarEnquiry') }
        it { should contain('filter_with FooBarQueryFilter') }
        it { should contain('query_with FooBarQuery') }
      end
    end

    it_should_behave_like 'a generator with a module', 'app/enquiries'
  end
end
