require 'spec_helper'
require 'generators/rspec/query/query_generator'

describe Rspec::Generators::QueryGenerator, :type => :generator do
  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_query_spec)
    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the spec" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('spec/queries/foo_bar_query_spec.rb') }

        it { should exist }
      end
    end
  end
end
