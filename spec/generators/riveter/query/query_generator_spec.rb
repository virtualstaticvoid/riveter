require 'spec_helper'
require 'generators/riveter/query/query_generator'

describe Riveter::Generators::QueryGenerator, :type => :generator do
  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_query_file)
    expect(gen).to receive(:create_module_file)

    # hooks
    expect(gen).to receive(:_invoke_from_option_test_framework)

    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the query" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('app/queries/foo_bar_query.rb') }

        it { should exist }
        it { should contain('class FooBarQuery') }
      end
    end

    it_should_behave_like 'a generator with a module', 'app/queries'
  end
end
