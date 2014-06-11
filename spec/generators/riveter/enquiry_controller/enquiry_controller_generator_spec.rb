require 'spec_helper'
require 'generators/riveter/enquiry_controller/enquiry_controller_generator'

describe Riveter::Generators::EnquiryControllerGenerator, :type => :generator do
  before do
    FileUtils.mkdir_p(file('config'))
    File.open(file('config/routes.rb'), 'w') {|f| f.write "TestApp::Application.routes.draw do\nend\n" }
  end

  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_enquiry_controller_file)
    expect(gen).to receive(:create_module_file)
    expect(gen).to receive(:add_enquiry_route)

    # hooks
    expect(gen).to receive(:_invoke_from_option_template_engine)
    expect(gen).to receive(:_invoke_from_option_test_framework)

    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the controller" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('app/controllers/foo_bar_enquiry_controller.rb') }

        it { should exist }
        it { should contain('enquiry_controller_for FooBarEnquiry') }
      end

      describe "with action names" do
        before do
          run_generator %w(foo_bar showme)
        end

        subject { file('app/controllers/foo_bar_enquiry_controller.rb') }

        it { should exist }
        it { should contain('enquiry_controller_for FooBarEnquiry, :action => :showme') }
      end
    end

    it_should_behave_like 'a generator with a module', 'app/controllers'
    it_should_behave_like 'a generator with output to routes', 'enquiry :foo_bar'
  end
end
