require 'spec_helper'

shared_examples_for "a generator with locale file output" do |file_name|
  describe "the generated files" do
    describe "the #{file_name}.en.yml" do
      describe "creates when missing" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file("config/locales/#{file_name}.en.yml") }

        it { should exist }
        it { should contain("#{file_name}:") }
      end

      describe "skips when exists" do
        before do
          FileUtils.mkdir_p(file('config/locales'))
          File.open(file("config/locales/#{file_name}.en.yml"), 'w') {|f| f.write 'untouched' }
          run_generator %w(foo_bar)
        end

        subject { file("config/locales/#{file_name}.en.yml") }

        it { should exist }
        it { should contain('untouched')}
      end
    end
  end
end

shared_examples_for "a generator with output to routes" do |route|
  describe "the generated files" do
    describe "the route" do
      before do
        run_generator %w(foo_bar)
      end

      subject { file('config/routes.rb') }

      it { should contain(route) }
    end
  end
end

shared_examples_for "a generator with a module" do |path|
  describe "the module" do
    before do
      run_generator %w(test_ns/foo_bar)
    end

    subject { file("#{path}/test_ns.rb") }

    it { should exist }
  end
end
