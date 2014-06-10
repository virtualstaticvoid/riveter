require 'spec_helper'
require 'riveter/enquiry_routes'

describe Riveter::EnquiryRoutes do
  describe "instance" do
    subject { TestEnquiryRoutes.new() }

    describe "#enquiry" do
      it { should respond_to(:enquiry) }

      it "should define a GET and POST route" do
        expect(subject).to receive(:get)
        expect(subject).to receive(:post)

        subject.enquiry :test_enquiry
      end

      it "should define a GET route for the :index action" do
        expect(subject).to receive(:get).with('test', {
          :controller => :test_enquiry,
          :as => :test_enquiry,
          :action => :index
        })
        allow(subject).to receive(:post)

        subject.enquiry :test
      end

      it "should define a POST route for the :index action" do
        allow(subject).to receive(:get)
        expect(subject).to receive(:post).with('test', {
          :controller => :test_enquiry,
          :as => nil,
          :action => :index
        })

        subject.enquiry :test
      end

      it "should allow overriding the controller" do
        expect(subject).to receive(:get).with('test', {
          :controller => :my_controller,
          :as => :test_enquiry,
          :action => :index
        })
        expect(subject).to receive(:post).with('test', {
          :controller => :my_controller,
          :as => nil,
          :action => :index
        })

        subject.enquiry :test, :controller => :my_controller
      end

      it "should allow overriding the path" do
        expect(subject).to receive(:get).with('do_some_thing', {
          :controller => :test_enquiry,
          :as => :test_enquiry,
          :action => :index
        })
        expect(subject).to receive(:post).with('do_some_thing', {
          :controller => :test_enquiry,
          :as => nil,
          :action => :index
        })

        subject.enquiry :test, :path => 'do_some_thing'
      end

      it "should allow overriding the path helper name" do
        expect(subject).to receive(:get).with('test', {
          :controller => :test_enquiry,
          :as => :path_name,
          :action => :index
        })
        expect(subject).to receive(:post).with('test', {
          :controller => :test_enquiry,
          :as => nil,
          :action => :index
        })

        subject.enquiry :test, :as => :path_name
      end

      it "should allow overriding the index action" do
        expect(subject).to receive(:get).with('test', {
          :controller => :test_enquiry,
          :as => :test_enquiry,
          :action => :my_new_action
        })
        expect(subject).to receive(:post).with('test', {
          :controller => :test_enquiry,
          :as => nil,
          :action => :my_new_action
        })

        subject.enquiry :test, :action => :my_new_action
      end
    end
  end
end
