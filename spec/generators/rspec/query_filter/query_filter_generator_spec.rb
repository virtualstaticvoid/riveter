require 'spec_helper'
require 'generators/rspec/query_filter/query_filter_generator'

describe Rspec::Generators::QueryFilterGenerator, :type => :generator do
  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_query_filter_spec)
    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the spec" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('spec/query_filters/foo_bar_query_filter_spec.rb') }

        it { should exist }
      end
    end
  end
end
