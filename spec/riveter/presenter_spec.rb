require 'spec_helper'

describe Riveter::Presenter do
  describe "#to_presenter" do
    subject { Object.new() }

    it { should respond_to(:to_presenter) }

    it {
      expect {
        subject.to_presenter(nil)
      }.to raise_error(ArgumentError)
    }

    it {
      expect {
        subject.to_presenter(Object)
      }.to raise_error(ArgumentError)
    }

    it { subject.to_presenter(TestPresenter).should_not be_nil }
    it { subject.to_presenter(TestPresenter).should be_instance_of(TestPresenter) }

    it { double(:instance, :name => :test).to_presenter(TestPresenter).should respond_to(:name) }
    it { double(:instance, :name => :test).to_presenter(TestPresenter).name.should eq(:test) }
  end

  describe "#with_presenter" do
    subject { [1, 2, 3].each }

    it { should respond_to(:with_presenter) }

    it {
      expect {
        subject.with_presenter(nil)
      }.to raise_error(ArgumentError)
    }

    it {
      expect {
        subject.with_presenter(Object)
      }.to raise_error(ArgumentError)
    }

    it { subject.with_presenter(TestPresenter).should_not be_nil }

    it "should yield to block for each item" do
      block = Mock::Block.new()
      expect(block).to receive(:call).exactly(subject.count).times
      subject.with_presenter(TestPresenter, &block)
    end

    it "should yield to block with the presenter for each item" do
      subject.with_presenter(TestPresenter) do |item|
        item.should be_instance_of(TestPresenter)
      end
    end

    it "should return enumerator if no block given" do
      block = Mock::Block.new()
      expect(block).to receive(:call).exactly(subject.count).times
      subject.with_presenter(TestPresenter).each(&block)
    end
  end

  describe "instance" do
    describe "#item" do
      subject { TestPresenter.new(:item) }
      it { should respond_to(:item) }
      it { subject.item.should eq(:item) }
    end

    describe "#method_missing" do
      let!(:item) {
        Class.new().class_eval do
          def some_method
          end

          self
        end.new()
      }

      describe "methods on item" do
        subject { TestPresenter.new(item) }

        it "respond_to? yields true" do
          should respond_to(:some_method)
        end

        it "delegates to item" do
          expect(item).to receive(:some_method)
          subject.some_method
        end
      end

      describe "methods on view" do
        let!(:view) {
          Class.new().class_eval do
            def some_other_method
            end

            self
          end.new()
        }

        subject { TestPresenter.new(item, view) }

        it "respond_to? yields true" do
          should respond_to(:some_other_method)
        end

        it "delegates to item" do
          expect(item).to receive(:some_method)
          subject.some_method
        end

        it "delegates to view" do
          expect(view).to receive(:some_other_method)

          subject.some_other_method
        end

        it "raise error if no method" do
          expect {
            subject.non_existent_method
          }.to raise_error
        end
      end
    end
  end
end
