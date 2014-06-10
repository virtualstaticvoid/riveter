require 'spec_helper'
require 'generators/haml/command_controller/command_controller_generator'

describe Haml::Generators::CommandControllerGenerator, :type => :generator do
  it "creates the view with defaults" do
    gen = generator %w(create_something)
    expect(gen).to receive(:create_template_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "creates the view with specified action name" do
    gen = generator %w(create_something create)
    expect(gen).to receive(:create_template_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "creates the view with specified action name and attributes" do
    gen = generator %w(create_something create name:string:required active:boolean other)
    expect(gen).to receive(:create_template_file)
    capture(:stdout) { gen.invoke_all }
  end

  describe "the generated files" do
    before do
      run_generator %w(create_something create name:string:required active:boolean other)
    end

    describe "the view" do
      subject { file('app/views/create_something_command/create.html.haml') }

      it { should exist }
    end
  end
end
