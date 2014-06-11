require 'spec_helper'
require 'generators/riveter/service/service_generator'

describe Riveter::Generators::ServiceGenerator, :type => :generator do
  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_service_file)
    expect(gen).to receive(:create_module_file)

    # hooks
    expect(gen).to receive(:_invoke_from_option_test_framework)

    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the service" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('app/services/foo_bar_service.rb') }

        it { should exist }
        it { should contain('class FooBarService') }
        it { should contain('register_as_handler_for FooBarCommand') }
      end
    end

    it_should_behave_like 'a generator with a module', 'app/services'
  end
end
