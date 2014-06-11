require 'spec_helper'
require 'generators/riveter/worker/worker_generator'

describe Riveter::Generators::WorkerGenerator, :type => :generator do
  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_worker_file)
    expect(gen).to receive(:create_module_file)

    # hooks
    expect(gen).to receive(:_invoke_from_option_test_framework)

    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the worker" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('app/workers/foo_bar_worker.rb') }

        it { should exist }
        it { should contain('class FooBarWorker') }
      end
    end

    it_should_behave_like 'a generator with a module', 'app/workers'
  end
end
