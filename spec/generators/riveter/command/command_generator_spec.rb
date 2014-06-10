require 'spec_helper'
require 'generators/riveter/command/command_generator'
require 'fileutils'

describe Riveter::Generators::CommandGenerator, :type => :generator do
  it "creates the command with defaults" do
    gen = generator %w(create_something --no-command-controller)
    expect(gen).to receive(:create_command_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "creates the command with specified attributes" do
    gen = generator %w(create_something name:string:required active:boolean other --no-command-controller)
    expect(gen).to receive(:create_command_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "creates a module file" do
    gen = generator %w(test_ns/create_something name:string:required active:boolean other --no-command-controller)
    expect(gen).to receive(:create_module_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "creates a locale file if it doesn't exist" do
    gen = generator %w(create_something --no-command-controller)
    expect(gen).to receive(:create_locale_file)
    capture(:stdout) { gen.invoke_all }
  end

  it "skips creating a locale file if it exists" do
    pending
  end

  describe "the generated files" do
    describe "the command" do
      before do
        run_generator %w(create_something name:string:required active:boolean other --no-command-controller)
      end

      subject { file('app/commands/create_something_command.rb') }

      it { should exist }
    end

    describe "the commands.en.yml locale" do
      before do
        FileUtils.mkdir_p(file('config/locales'))
        File.open(file('config/locales/commands.en.yml'), 'w') {|f| f.write 'empty' }
        run_generator %w(create_something name:string:required active:boolean other --no-command-controller)
      end

      subject { file('config/locales/commands.en.yml') }

      it { should exist }
      it { File.open(file('config/locales/commands.en.yml'), 'r') {|f| f.read }.should eq('empty') }
    end
  end
end
