require 'spec_helper'
require 'generators/haml/enquiry_controller/enquiry_controller_generator'

describe Haml::Generators::EnquiryControllerGenerator, :type => :generator do
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

        subject { file('app/views/foo_bar_enquiry/index.html.haml') }

        it { should exist }
        it { should contain('= enquiry_form_for') }
      end

      describe "with specified action name" do
        before do
          run_generator %w(foo_bar baz)
        end

        subject { file('app/views/foo_bar_enquiry/baz.html.haml') }

        it { should exist }
        it { should contain('= enquiry_form_for') }
      end

      describe "with specified action name and attributes" do
        before do
          run_generator %w(foo_bar baz qux:string quux:string:required corge:enum grault:boolean garply:model other)
        end

        subject { file('app/views/foo_bar_enquiry/baz.html.haml') }

        it { should exist }
        it { should contain('= enquiry_form_for') }
        it { should contain('= f.input :qux') }
        it { should contain('= f.input :quux') }
        it { should contain('= f.input :corge, :collection => CorgeEnum.collection') }
        it { should contain('= f.input :grault') }
        it { should contain('= f.input :garply, :collection => Garply.all') }
        it { should contain('= f.input :other') }
      end
    end
  end
end
