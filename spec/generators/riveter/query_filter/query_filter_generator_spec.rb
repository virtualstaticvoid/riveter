require 'spec_helper'
require 'generators/riveter/query_filter/query_filter_generator'

describe Riveter::Generators::QueryFilterGenerator, :type => :generator do
  before do
    FileUtils.mkdir_p(file('config/locales'))
    File.open(file('config/routes.rb'), 'w') {|f| f.write "TestApp::Application.routes.draw do\nend\n" }
  end

  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_query_filter_file)
    expect(gen).to receive(:create_module_file)
    expect(gen).to receive(:create_locale_file)

    # hooks
    expect(gen).to receive(:_invoke_from_option_test_framework)

    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the query filter" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('app/query_filters/foo_bar_query_filter.rb') }

        it { should exist }
        it { should contain('class FooBarQueryFilter') }
      end

      describe "with attributes" do
        before do
          run_generator %w(foo_bar name:string:required active:boolean other)
        end

        subject { file('app/query_filters/foo_bar_query_filter.rb') }

        it { should exist }
        it { should contain('class FooBarQueryFilter') }
        it { should contain('attr_string :name, :required => true') }
        it { should contain('attr_boolean :active') }
        it { should contain('attr_string :other') }
      end
    end

    it_should_behave_like 'a generator with a module', 'app/query_filters'
    it_should_behave_like 'a generator with locale file output', 'query_filters'
  end
end
