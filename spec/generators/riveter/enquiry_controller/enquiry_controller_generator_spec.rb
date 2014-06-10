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

    describe "the module" do
      before do
        run_generator %w(test_ns/foo_bar)
      end

      subject { file('app/controllers/test_ns.rb') }

      it { should exist }
    end

    describe "the route" do
      before do
        run_generator %w(foo_bar)
      end

      subject { file('config/routes.rb') }

      it { should contain('enquiry :foo_bar') }
    end
  end
end
