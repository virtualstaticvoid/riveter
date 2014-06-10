require 'spec_helper'
require 'generators/haml/command_controller/command_controller_generator'

describe Haml::Generators::CommandControllerGenerator, :type => :generator do
  it "should run all tasks in the generator" do
    gen = generator %w(foo_bar)
    expect(gen).to receive(:create_template_file)
    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    describe "the view" do
      describe "with defaults" do
        before do
          run_generator %w(foo_bar)
        end

        subject { file('app/views/foo_bar_command/new.html.haml') }

        it { should exist }
        it { should contain('= command_form_for') }
      end

      describe "with specified action name" do
        before do
          run_generator %w(foo_bar create)
        end

        subject { file('app/views/foo_bar_command/create.html.haml') }

        it { should exist }
        it { should contain('= command_form_for') }
      end

      describe "with specified action name and attributes" do
        before do
          run_generator %w(foo_bar create name:string:required active:boolean other)
        end

        subject { file('app/views/foo_bar_command/create.html.haml') }

        it { should exist }
        it { should contain('= command_form_for') }
        it { should contain('= f.input :name') }
      end
    end
  end
end
