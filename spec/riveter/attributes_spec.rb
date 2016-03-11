require 'spec_helper'

describe Riveter::Attributes do
  describe "class" do
    subject do
      # create an anonymous class
      Class.new().class_eval {
        include Riveter::Attributes

        def self.name
          'TestClass'
        end

        self
      }
    end

    describe ".attributes" do
      it { subject.attributes.should_not be_nil }
      it { subject.attributes.should be_a(Array) }

      it "each class has it's own set" do
        subject.attributes.should_not eq(TestClassWithAttributes.attributes)
      end
    end

    it_should_behave_like "an attribute", :string, 'A' do
      let(:assigned_value) { 'B' }
    end

    it_should_behave_like "an attribute", :text, 'B' do
      let(:assigned_value) { 'C' }
    end

    it_should_behave_like "an attribute", :integer, 1 do
      let(:assigned_value) { '2' }
      let(:expected_value) { 2 }

      describe "additional" do
        before do
          subject.attr_integer :an_attribute
        end
        let(:instance) { subject.new() }

        it { instance.should validate_numericality_of(:an_attribute) }
      end
    end

    it_should_behave_like "an attribute", :date, Date.new(2010, 1, 12) do
      let(:assigned_value) { '2010-01-13' }
      let(:expected_value) { Date.new(2010, 1, 13) }

      describe "additional" do
        before do
          subject.attr_date :an_attribute
        end
        let(:instance) { subject.new() }

        it { instance.should validate_timeliness_of(:an_attribute) }
      end
    end

    it_should_behave_like "an attribute", :date_range, Date.new(2010, 1, 12)..Date.new(2012, 1, 11) do
      describe "additional" do
        before do
          subject.attr_date_range :an_attribute
        end
        let(:instance) { subject.new() }

        it { instance.should validate_timeliness_of(:an_attribute_from) }
        it { instance.should validate_timeliness_of(:an_attribute_to) }

        it { instance.should respond_to(:an_attribute_from?) }

        it {
          instance.an_attribute = nil
          instance.an_attribute_from?.should be_falsey
        }

        it {
          instance.an_attribute_from = Date.today
          instance.an_attribute_from?.should be_truthy
        }

        it { instance.should respond_to(:an_attribute_to?) }

        it { instance.should respond_to(:an_attribute_present?) }

        it {
          instance.an_attribute = nil
          instance.an_attribute_to?.should be_falsey
        }

        it {
          instance.an_attribute_to = Date.today
          instance.an_attribute_to?.should be_truthy
        }

        it {
          instance.an_attribute_from = Date.today
          instance.an_attribute_to = Date.today
          instance.an_attribute_present?.should be_truthy
        }

        it {
          instance.an_attribute_from = nil
          instance.an_attribute_to = Date.today
          instance.an_attribute_present?.should be_falsey
        }

        it {
          instance.an_attribute_from = Date.today
          instance.an_attribute_to = nil
          instance.an_attribute_present?.should be_falsey
        }

        it {
          instance.an_attribute_from = Date.today
          instance.an_attribute_to = Date.today
          instance.an_attribute_present?.should be_truthy
        }

      end

      describe "#min" do
        before do
          subject.attr_date_range :an_attribute_value, :min => 1
          subject.attr_date_range :an_attribute_block, :min => lambda { self.some_method }
        end

        let(:instance) { subject.new() }

        it { instance.should respond_to(:an_attribute_value_min) }
        it { instance.should respond_to(:an_attribute_value_min=) }

        it {
          instance.an_attribute_value_min.should eq(1)
        }

        it {
          instance.an_attribute_value_min = 2
          instance.an_attribute_value_min.should eq(2)
        }

        it "invokes the lambda in the context of self" do
          expect(instance).to receive(:some_method)
          instance.an_attribute_block_min
        end
      end

      describe "#max" do
        before do
          subject.attr_date_range :an_attribute_value, :max => 1
          subject.attr_date_range :an_attribute_block, :max => lambda { self.some_method }
        end

        let(:instance) { subject.new() }

        it { instance.should respond_to(:an_attribute_value_max) }
        it { instance.should respond_to(:an_attribute_value_max=) }

        it {
          instance.an_attribute_value_max.should eq(1)
        }

        it {
          instance.an_attribute_value_max = 2
          instance.an_attribute_value_max.should eq(2)
        }

        it "invokes the lambda in the context of self" do
          expect(instance).to receive(:some_method)
          instance.an_attribute_block_max
        end
      end

    end

    it_should_behave_like "an attribute", :time, Time.new(2010, 1, 12, 8, 4, 45) do
      let(:assigned_value) { '2010-01-12 08:04:12' }
      let(:expected_value) { Time.new(2010, 1, 12, 8, 4, 12) }

      describe "additional" do
        before do
          subject.attr_time :an_attribute
        end
        let(:instance) { subject.new() }

        it { instance.should validate_timeliness_of(:an_attribute) }
      end
    end

    it_should_behave_like "an attribute", :boolean, true do
      let(:assigned_value) { '0' }
      let(:expected_value) { false }
    end

    it_should_behave_like "an attribute", :enum, TestEnum::Member1, TestEnum do
      let(:assigned_value) { 'Member2' }
      let(:expected_value) { TestEnum::Member2 }

      describe "additional" do
        before do
          subject.attr_enum :product_type, TestEnum, :required => true
        end
        let(:instance) { subject.new() }

        it { instance.should validate_inclusion_of(:product_type).in_array(TestEnum.values) }
      end
    end

    it_should_behave_like "an attribute", :array, [1, 2, 3] do
      let(:assigned_value) { %w(5 6 7) }
      let(:expected_value) { [5, 6, 7] }
    end

    it_should_behave_like "an attribute", :hash, {:a => :b} do
      let(:assigned_value) { {:c => '1', :d => '2'} }
      let(:expected_value) { {:c => 1, :d => 2} }
    end

    it_should_behave_like "an attribute", :object, Object.new() do
      let(:assigned_value) { Object.new() }
    end

    it_should_behave_like "an attribute", :class, TestModel, [TestModel, TestModelWithAttributeDefaultValues] do
      let(:assigned_value) { "TestModelWithAttributeDefaultValues" }
      let(:expected_value) { TestModelWithAttributeDefaultValues }

      describe "additional" do
        before do
          subject.attr_class :an_attribute, [TestModel, TestModelWithAttributeDefaultValues], :required => true
        end
        let(:instance) { subject.new() }

        it { instance.should validate_inclusion_of(:an_attribute).in_array([TestModel, TestModelWithAttributeDefaultValues]) }
      end
    end
  end

  describe "instance" do
    subject { TestClassWithAttributes.new() }

    describe "#initialize" do
      it "assigns attribute default values" do
        subject.string.should eq('A')
        subject.text.should eq('b')
        subject.integer.should eq(1)
        subject.decimal.should eq(9.998)
        subject.date.should eq(Date.new(2010, 1, 12))
        subject.date_range.should eq(Date.new(2010, 1, 12)..Date.new(2011, 1, 12))
        subject.date_range_from.should eq(Date.new(2010, 1, 12))
        subject.date_range_to.should eq(Date.new(2011, 1, 12))
        subject.time.should eq(Time.new(2010, 1, 12, 14, 56))
        subject.boolean.should eq(true)
        subject.enum.should eq(TestEnum::Member1)
        subject.array.should eq([1, 2, 3])
        subject.hash.should eq({:a => :b})
        subject.object.should eq('whatever')
      end
    end

    describe "#attributes" do
      it { subject.attributes.should_not be_nil }
      it { subject.attributes.should be_a(Hash) }
      it {
        subject.attributes.should eq({
          'string' => 'A',
          'text' => 'b',
          'integer' => 1,
          'decimal' => 9.998,
          'date' => Date.new(2010, 1, 12),
          'date_range' => Date.new(2010, 1, 12)..Date.new(2011, 1, 12),
          'date_range_from' => Date.new(2010, 1, 12),
          'date_range_to' => Date.new(2011, 1, 12),
          'time' => Time.new(2010, 1, 12, 14, 56),
          'boolean' => true,
          'enum' => TestEnum::Member1,
          'array' => [1, 2, 3],
          'hash' => {:a => :b},
          'object' => 'whatever'
        })
      }
    end

    describe "#persisted?" do
      it { subject.persisted?.should be_falsey }
    end

    describe "#column_for_attribute" do
      it { subject.column_for_attribute(:string).should_not be_nil }
      it { subject.column_for_attribute(:string).name.should eq(:string) }
    end

    describe "#filter_params" do
      it "filters out unknown attributes" do
        params = subject.send(:filter_params, :string => 'AA', :unknown => :value)
        params.should include(:string)
        params.should_not include(:unknown)
      end
    end

    describe "#clean_params" do
      it "removes blank attributes" do
        params = subject.send(:clean_params, :string => '')
        params.should_not include(:string)
      end

      it "removes nil attributes" do
        params = subject.send(:clean_params, :string => nil)
        params.should_not include(:string)
      end

      describe "nested attribute arrays" do
        it "removes blank attributes" do
          params = subject.send(:clean_params, :string => [1, 2, ''])
          params.should include(:string)
          params[:string].length.should eq(2)
        end

        it "removes nil attributes" do
          params = subject.send(:clean_params, :string => [1, 2, nil])
          params.should include(:string)
          params[:string].length.should eq(2)
        end
      end

      describe "nested attribute hashes" do
        it "removes blank attributes" do
          params = subject.send(:clean_params, :string => { :a => 'A', :b => '' })
          params.should include(:string)
          params[:string].should_not include(:b)
        end

        it "removes nil attributes" do
          params = subject.send(:clean_params, :string => { :a => 'A', :b => nil })
          params.should include(:string)
          params[:string].should_not include(:b)
        end
      end
    end

    describe "#apply_params" do
      it "assigns attributes" do
        subject.string.should eq('A')
        subject.send(:apply_params, :string => 'test')
        subject.string.should eq('test')
      end

      it "raises UnknownAttributeError for unknown attribute" do
        expect {
          subject.send(:apply_params, :unknown => 'test')
        }.to raise_error(Riveter::UnknownAttributeError)
      end

      it "re-raises error attribute" do
        allow(subject).to receive(:string=).and_raise(ArgumentError)
        expect {
          subject.send(:apply_params, :string => 'test')
        }.to raise_error(ArgumentError)
      end
    end
  end
end
