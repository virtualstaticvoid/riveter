require 'spec_helper'
require 'generators/rspec/command_controller/command_controller_generator'

describe Rspec::Generators::CommandControllerGenerator, :type => :generator do
  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_command_controller_spec)
    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the spec" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('spec/controllers/foo_bar_command_controller_spec.rb') }

        it { should exist }
      end

      describe "with action names" do
        before do
          run_generator %w(foo_bar baz qux)
        end

        subject { file('spec/controllers/foo_bar_command_controller_spec.rb') }

        it { should exist }
        it { should contain("GET 'baz'") }
        it { should contain("POST 'qux'") }
      end
    end
  end
end
