require 'spec_helper'
require 'generators/haml/enquiry_controller/enquiry_controller_generator'

describe Haml::Generators::EnquiryControllerGenerator, :type => :generator do
  it "creates the view with defaults" do
    gen = generator %w(list_something)
    expect(gen).to receive(:create_template_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "creates the view with specified action name" do
    gen = generator %w(list_something list)
    expect(gen).to receive(:create_template_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "creates the view with specified action name and attributes" do
    gen = generator %w(list_something list name:string:required active:boolean other)
    expect(gen).to receive(:create_template_file)
    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    before do
      run_generator %w(list_something list name:string:required active:boolean other)
    end

    describe "the view" do
      subject { file('app/views/list_something_enquiry/list.html.haml') }

      it { should exist }
    end
  end
end
