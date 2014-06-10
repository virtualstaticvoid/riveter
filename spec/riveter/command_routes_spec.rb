require 'spec_helper'
require 'riveter/command_routes'

describe Riveter::CommandRoutes do
  describe "instance" do
    subject { TestCommandRoutes.new() }

    describe "#command" do
      it { should respond_to(:command) }

      it "should define a GET and POST route" do
        expect(subject).to receive(:get)
        expect(subject).to receive(:post)

        subject.command :test_command
      end

      it "should define a GET route for the :new action" do
        expect(subject).to receive(:get).with('test', {
          :controller => :test_command,
          :as => :test_command,
          :action => :new
        })
        allow(subject).to receive(:post)

        subject.command :test
      end

      it "should define a POST route for the :create action" do
        allow(subject).to receive(:get)
        expect(subject).to receive(:post).with('test', {
          :controller => :test_command,
          :as => nil,
          :action => :create
        })

        subject.command :test
      end

      it "should allow overriding the controller" do
        expect(subject).to receive(:get).with('test', {
          :controller => :my_controller,
          :as => :test_command,
          :action => :new
        })
        expect(subject).to receive(:post).with('test', {
          :controller => :my_controller,
          :as => nil,
          :action => :create
        })

        subject.command :test, :controller => :my_controller
      end

      it "should allow overriding the path" do
        expect(subject).to receive(:get).with('do_some_thing', {
          :controller => :test_command,
          :as => :test_command,
          :action => :new
        })
        expect(subject).to receive(:post).with('do_some_thing', {
          :controller => :test_command,
          :as => nil,
          :action => :create
        })

        subject.command :test, :path => 'do_some_thing'
      end

      it "should allow overriding the path helper name" do
        expect(subject).to receive(:get).with('test', {
          :controller => :test_command,
          :as => :path_name,
          :action => :new
        })
        expect(subject).to receive(:post).with('test', {
          :controller => :test_command,
          :as => nil,
          :action => :create
        })

        subject.command :test, :as => :path_name
      end

      it "should allow overriding the new action" do
        expect(subject).to receive(:get).with('test', {
          :controller => :test_command,
          :as => :test_command,
          :action => :my_new_action
        })
        expect(subject).to receive(:post).with('test', {
          :controller => :test_command,
          :as => nil,
          :action => :create
        })

        subject.command :test, :new_action => :my_new_action
      end

      it "should allow overriding the create action" do
        expect(subject).to receive(:get).with('test', {
          :controller => :test_command,
          :as => :test_command,
          :action => :new
        })
        expect(subject).to receive(:post).with('test', {
          :controller => :test_command,
          :as => nil,
          :action => :my_create_action
        })

        subject.command :test, :create_action => :my_create_action
      end
    end
  end
end
