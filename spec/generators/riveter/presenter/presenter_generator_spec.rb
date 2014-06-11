require 'spec_helper'
require 'generators/riveter/presenter/presenter_generator'

describe Riveter::Generators::PresenterGenerator, :type => :generator do
  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_presenter_file)
    expect(gen).to receive(:create_module_file)

    # hooks
    expect(gen).to receive(:_invoke_from_option_test_framework)

    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the presenter" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('app/presenters/foo_bar_presenter.rb') }

        it { should exist }
        it { should contain('class FooBarPresenter') }
      end
    end

    it_should_behave_like 'a generator with a module', 'app/presenters'
  end
end
