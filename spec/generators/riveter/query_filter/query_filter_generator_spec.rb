require 'spec_helper'
require 'generators/riveter/query_filter/query_filter_generator'
require 'fileutils'

describe Riveter::Generators::QueryFilterGenerator, :type => :generator do
  it "creates the query filter with defaults" do
    gen = generator %w(active_items)
    expect(gen).to receive(:create_query_filter_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "creates the query filter with specified attributes" do
    gen = generator %w(active_items name:string:required active:boolean other)
    expect(gen).to receive(:create_query_filter_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "creates a module file" do
    gen = generator %w(test_ns/active_items name:string:required active:boolean other)
    expect(gen).to receive(:create_module_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "creates a locale file if it doesn't exist" do
    gen = generator %w(active_items)
    expect(gen).to receive(:create_locale_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "skips creating a locale file if it exists" do
    pending
  end

  describe "the generated files" do
    describe "the query filter" do
      before do
        run_generator %w(active_items name:string:required active:boolean other)
      end

      subject { file('app/query_filters/active_items_query_filter.rb') }

      it { should exist }
    end

    describe "the commands.en.yml locale" do
      before do
        FileUtils.mkdir_p(file('config/locales'))
        File.open(file('config/locales/query_filters.en.yml'), 'w') {|f| f.write 'empty' }
        run_generator %w(active_items name:string:required active:boolean other)
      end

      subject { file('config/locales/query_filters.en.yml') }

      it { should exist }
      it { File.open(file('config/locales/query_filters.en.yml'), 'r') {|f| f.read }.should eq('empty') }
    end
  end
end
