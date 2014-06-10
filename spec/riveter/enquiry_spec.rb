require 'spec_helper'

describe Riveter::Enquiry do
  describe "class" do
    subject { TestEnquiry }

    describe ".enquiry_name" do
      it { should respond_to(:enquiry_name) }
      it { subject.enquiry_name.should be_a(ActiveModel::Name) }
    end

    describe ".i18n_scope" do
      it { should respond_to(:i18n_scope) }
      it { subject.i18n_scope.should eq(:enquiries) }
    end

    describe ".filter_with" do
      subject {
        Class.new(Riveter::Enquiry::Base).instance_eval do
          def enquiry_name
            ActiveModel::Name.new(self, nil, 'TestEnquiry')
          end

          self
        end
      }

      it { should respond_to(:filter_with) }

      describe "called without a class or block" do
        it "raise an error" do
          expect {
            subject.filter_with
          }.to raise_error(ArgumentError)
        end
      end

      describe "called with a class" do
        it {
          klass = Class.new(Riveter::QueryFilter::Base)
          subject.filter_with(klass)
          subject.query_with {}
          subject.new().query_filter_class.should eq(klass)
        }
      end

      describe "called with a block" do
        it "invokes the block" do
          block = Mock::Block.new()
          expect(block).to receive(:call).at_least(:once)
          subject.filter_with do
            block.call
          end
        end

        it "creates an anonymous class" do
          block = Mock::Block.new()
          allow(block).to receive(:call)

          subject.filter_with do
            block.call
          end

          subject.query_with {}

          subject.new().query_filter.should be_a_kind_of(Riveter::QueryFilter::Base)
        end

        it "adds a .model_name method" do
          subject.filter_with {}

          # for forms support
          subject.query_filter_class.should respond_to(:model_name)
          subject.query_filter_class.model_name.should eq(subject.enquiry_name)
        end
      end
    end

    describe ".query_filter_class" do
      it { should respond_to(:query_filter_class) }
      it { subject.query_filter_class.should eq(TestQueryFilter) }
    end

    describe ".query_filter_attributes" do
      it { should respond_to(:query_filter_attributes) }
      it { subject.query_filter_attributes.should eq(TestQueryFilter.attributes) }
    end

    describe ".query_with" do
      subject {
        Class.new(Riveter::Enquiry::Base).instance_eval do
          def enquiry_name
            ActiveModel::Name.new(self, nil, 'TestEnquiry')
          end

          filter_with {}

          self
        end
      }

      it { should respond_to(:query_with) }

      describe "called without a class or block" do
        it "raise an error" do
          expect {
            subject.query_with
          }.to raise_error(ArgumentError)
        end
      end

      describe "called with a class" do
        it {
          klass = Class.new(Riveter::Query::Base)
          subject.query_with(klass)
          subject.new().query_class.should eq(klass)
        }
      end

      describe "called with a block" do
        it "invokes the block" do
          block = Mock::Block.new()
          allow(subject).to receive(:create_query_filter) { OpenStruct.new(:valid? => true) }

          expect(block).to receive(:call).at_least(:once)

          subject.query_with do |filter|
            block.call
          end

          subject.new().submit()
        end

        it "creates an anonymous class" do
          block = Mock::Block.new()
          allow(block).to receive(:call)

          subject.query_with do |filter|
            block.call
          end

          subject.new().query_class.new(:query_filter).should be_a_kind_of(Riveter::Query::Base)
        end
      end
    end

    describe ".query_class" do
      it { should respond_to(:query_class) }
      it { subject.query_class.should eq(TestQuery) }
    end
  end

  describe "instance" do
    context "with incorrectly configured" do
      it "fails when no filter or query set" do
        expect {
          Class.new(Riveter::Enquiry::Base).new()
        }.to raise_error
      end

      it "fails when no query set" do
        expect {
          Class.new(Riveter::Enquiry::Base).tap {|klass|
            klass.filter_with TestQueryFilter
          }.new()
        }.to raise_error
      end

      it "fails when no filter set" do
        expect {
          Class.new(Riveter::Enquiry::Base).tap {|klass|
            klass.query_with TestQuery
          }.new()
        }.to raise_error
      end
    end

    context "with correctly configured" do
      subject { TestEnquiry.new() }

      describe "#query_filter_class" do
        it { subject.query_filter_class.should eq(TestQueryFilter) }
      end

      describe "#query_class" do
        it { subject.query_class.should eq(TestQuery) }
      end

      describe "#query_filter" do
        it { should respond_to(:filter) }
        it { subject.query_filter.should be_a(TestQueryFilter)}
      end

      describe "#query_filter_attributes" do
        it { subject.query_filter_attributes.should eq(TestQueryFilter.attributes)}
      end

      describe "#submit" do
        it "yields the query for a valid filter" do
          query = Object.new()
          expect(subject).to receive(:create_query_filter) { OpenStruct.new(:valid? => true) }
          expect(subject).to receive(:create_query) { query }
          subject.submit().should eq(query)
        end

        it "yields false for an invalid filter" do
          expect(subject).to receive(:create_query_filter) { OpenStruct.new(:valid? => false) }
          subject.submit().should eq(false)
        end

        it "assigns query" do
          query = Object.new()
          expect(subject).to receive(:create_query_filter) { OpenStruct.new(:valid? => true) }
          expect(subject).to receive(:create_query) { query }
          subject.submit()
          subject.query.should eq(query)
        end
      end

      describe "#query" do
        it { should respond_to(:query) }
      end

      describe "#find_each" do
        it "invokes the given block when data" do
          allow(subject).to receive(:query) { [1] }
          block = Mock::Block.new()
          expect(block).to receive(:call).at_least(:once)
          subject.find_each(&block)
        end

        it "does not invoke the given block when query nil" do
          allow(subject).to receive(:query) { nil }
          block = Mock::Block.new()
          expect(block).to_not receive(:call)
          subject.find_each(&block)
        end

        it "does not invoke the given block when no data" do
          allow(subject).to receive(:query) { [] }
          block = Mock::Block.new()
          expect(block).to_not receive(:call)
          subject.find_each(&block)
        end
      end

      describe "#has_data?" do
        it "yields false when query nil" do
          allow(subject).to receive(:query) { nil }
          subject.has_data?.should be_false
        end

        it "yields false when query empty" do
          allow(subject).to receive(:query) { OpenStruct.new(:has_data? => false) }
          subject.has_data?.should be_false
        end

        it "yields true when query data" do
          allow(subject).to receive(:query) { OpenStruct.new(:has_data? => true) }
          subject.has_data?.should be_true
        end
      end

      describe "#query_results" do
        it { should respond_to(:query_results) }

        it "yield false when invalid query" do
          subject.query_results.should be_nil
        end

        it "yield query relation for a valid query" do
          allow(subject).to receive(:query) { OpenStruct.new(:has_data? => true, :relation => []) }

          subject.query_results.should eq([])
        end
      end

      describe "#create_query_filter" do
        it "should create an instance" do
          subject.send(:create_query_filter, {}).should be_a(TestQueryFilter)
        end

        it "should assign params" do
          subject.send(:create_query_filter, {:name => 'test'}).name.should eq('test')
        end
      end

      describe "#create_query" do
        it "should create an instance" do
          subject.send(:create_query, {}).should be_a(TestQuery)
        end

        it "should assign filter" do
          subject.send(:create_query, 'test').query_filter.should eq('test')
        end
      end
    end
  end
end
