require 'spec_helper'
require 'generators/rspec/worker/worker_generator'

describe Rspec::Generators::WorkerGenerator, :type => :generator do
  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_worker_spec)
    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the spec" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('spec/workers/foo_bar_worker_spec.rb') }

        it { should exist }
      end
    end
  end
end
