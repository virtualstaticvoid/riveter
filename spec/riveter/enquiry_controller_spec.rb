require 'spec_helper'

describe Riveter::EnquiryController do
  context "when not configured" do
    describe "class" do
      subject { TestEnquiryController }

      it { should respond_to(:enquiry_controller_for) }
      it { should_not respond_to(:enquiry_class) }
      it { should_not respond_to(:enquiry_options) }
    end

    describe "instance" do
      subject { TestEnquiryController.new }

      it { should_not respond_to(:index) }
    end
  end

  context "when configured" do
    describe "class" do
      subject { TestTestEnquiryController }

      it { should respond_to(:enquiry_controller_for) }
    end

    describe "instance" do
      subject { TestTestEnquiryController.new }

      it { should respond_to(:enquiry_class) }
      it { should respond_to(:enquiry_options) }
      it { should respond_to(:index) }

      describe "#enquiry_class" do
        it { subject.enquiry_class.should eq(TestEnquiry) }
      end

      describe "#enquiry_options" do
        it { subject.enquiry_options.should have_key(:as) }
        it { subject.enquiry_options.should have_key(:attributes) }

        it { subject.enquiry_options[:as].should eq('test') }
        it { subject.enquiry_options[:attributes].should eq(TestEnquiry.query_filter_attributes) }
      end

      describe "controller action" do
        describe "#index" do
          context "without params" do
            before do
              allow(subject).to receive(:params) { ActionController::Parameters.new({}) }
            end

            it "assigns @enquiry" do
              subject.index
              subject.send(:eval, '@enquiry').should_not be_nil
            end
          end

          context "with params" do
            before do
              allow(subject).to receive(:params) { ActionController::Parameters.new({:test => {:name => 'test'}}) }
            end

            it "assigns @enquiry" do
              subject.index
              subject.send(:eval, '@enquiry').should_not be_nil
            end

            it "assigns attributes" do
              subject.index
              enquiry = subject.send(:eval, '@enquiry')
              enquiry.filter.name.should eq('test')
            end

            context "for a valid enquiry" do
              before do
                allow_any_instance_of(TestEnquiry).to receive(:submit) { true }
              end

              it "assigns @enquiry" do
                subject.index
                subject.send(:eval, '@enquiry').should_not be_nil
              end

              it "invokes 'on_success' if defined" do
                expect(subject).to receive(:on_success).with(kind_of(TestEnquiry))
                subject.index
              end
            end

            context "for an invalid enquiry" do
              before do
                allow_any_instance_of(TestEnquiry).to receive(:submit) { false }
              end

              it "assigns @enquiry" do
                subject.index
                subject.send(:eval, '@enquiry').should_not be_nil
              end

              it "invokes 'on_failure' if defined" do
                expect(subject).to receive(:on_failure).with(kind_of(TestEnquiry))
                subject.index
              end
            end
          end

          context "with reset param" do
            before do
              allow(subject).to receive(:params) { ActionController::Parameters.new({:reset => 'reset', :test => {:name => 'test'}}) }
            end

            it "assigns @enquiry" do
              subject.index
              subject.send(:eval, '@enquiry').should_not be_nil
            end

            it "clears attributes" do
              subject.index
              enquiry = subject.send(:eval, '@enquiry')
              enquiry.filter.name.should be_blank
            end
          end
        end
      end
    end
  end
end
