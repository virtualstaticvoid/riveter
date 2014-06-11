require 'spec_helper'
require 'generators/riveter/enum/enum_generator'

describe Riveter::Generators::EnumGenerator, :type => :generator do
  before do
    FileUtils.mkdir_p(file('config/locales'))
  end

  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_enum_file)
    expect(gen).to receive(:create_module_file)
    expect(gen).to receive(:create_locale_file)

    # hooks
    expect(gen).to receive(:_invoke_from_option_test_framework)

    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the enum" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('app/enums/foo_bar_enum.rb') }

        it { should exist }
        it { should contain('module FooBarEnum') }
      end

      describe "with members (implied as integers)" do
        before do
          run_generator %w(foo_bar baz qux)
        end

        subject { file('app/enums/foo_bar_enum.rb') }

        it { should exist }
        it { should contain('module FooBarEnum') }
        it { should contain('Baz = 1') }
        it { should contain('Qux = 2') }
      end

      describe "with members and values" do
        before do
          run_generator %w(foo_bar baz:10 qux:20)
        end

        subject { file('app/enums/foo_bar_enum.rb') }

        it { should exist }
        it { should contain('module FooBarEnum') }
        it { should contain('Baz = 10') }
        it { should contain('Qux = 20') }
      end
    end

    it_should_behave_like 'a generator with a module', 'app/enums'
    it_should_behave_like 'a generator with locale file output', 'enums'
  end
end
