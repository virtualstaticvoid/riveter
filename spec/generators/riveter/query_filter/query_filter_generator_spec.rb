require 'spec_helper'
require 'generators/riveter/query_filter/query_filter_generator'

describe Riveter::Generators::QueryFilterGenerator, :type => :generator do
  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_query_filter_file)
    expect(gen).to receive(:create_module_file)
    expect(gen).to receive(:create_locale_file)
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

    describe "the module" do
      before do
        run_generator %w(test_ns/foo_bar)
      end

      subject { file('app/query_filters/test_ns.rb') }

      it { should exist }
    end

    describe "the commands.en.yml" do
      describe "creates when missing" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('config/locales/query_filters.en.yml') }

        it { should exist }
        it { should contain('query_filters:') }
      end

      describe "skips when exists" do
        before do
          FileUtils.mkdir_p(file('config/locales'))
          File.open(file('config/locales/query_filters.en.yml'), 'w') {|f| f.write 'untouched' }
          run_generator %w(foo_bar)
        end

        subject { file('config/locales/query_filters.en.yml') }

        it { should exist }
        it { should contain('untouched')}
      end
    end
  end
end
