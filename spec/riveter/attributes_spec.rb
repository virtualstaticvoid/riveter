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

      describe "additional" do
        before do
          subject.attr_boolean :an_attribute
        end
        let(:instance) { subject.new() }

        it { instance.should validate_booleaness_of(:an_attribute) }
      end
    end

    it_should_behave_like "an attribute", :enum, TestEnum::Member1, TestEnum do
      let(:assigned_value) { 'Member2' }
      let(:expected_value) { TestEnum::Member2 }

      describe "additional" do
        before do
          subject.attr_enum :product_type, TestEnum, :required => true
        end
        let(:instance) { subject.new() }

        it { instance.should ensure_inclusion_of(:product_type).in_array(TestEnum.all) }

        it { should respond_to(:product_type_enum)}
        it { subject.product_type_enum.should eq(TestEnum) }
        it { should respond_to(:product_types)}
        it { subject.product_types.should eq(TestEnum.collection)}
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

    it_should_behave_like "an attribute", :model, 1, TestModel do

      before do
        allow_any_instance_of(TestModel).to receive(:find_by) { self }
      end

      let(:assigned_value) { TestModel.new() }

      describe "additional" do
        before do
          subject.attr_model :product, TestModel
        end

        it { should respond_to(:product_model)}
        it { subject.product_model.should eq(TestModel) }
      end
    end

    it_should_behave_like "an attribute", :object, Object.new() do
      let(:assigned_value) { Object.new() }
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
        subject.time.should eq(Time.new(2010, 1, 12, 14, 56))
        subject.boolean.should eq(true)
        subject.enum.should eq(TestEnum::Member1)
        subject.array.should eq([1, 2, 3])
        subject.hash.should eq({:a => :b})
        subject.model.should eq(TestModel)
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
          'time' => Time.new(2010, 1, 12, 14, 56),
          'boolean' => true,
          'enum' => TestEnum::Member1,
          'array' => [1, 2, 3],
          'hash' => {:a => :b},
          'model' => TestModel,
          'object' => 'whatever'
        })
      }
    end

    describe "#persisted?" do
      it { subject.persisted?.should be_false }
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
