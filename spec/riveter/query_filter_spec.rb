require 'spec_helper'

describe Riveter::QueryFilter do
  it_should_behave_like "a class with attributes", TestQueryFilter

  describe "class" do
    subject { TestQueryFilter }

    describe ".filter_name" do
      it { should respond_to(:filter_name) }
      it { subject.filter_name.should be_a(ActiveModel::Name) }
    end

    describe ".i18n_scope" do
      it { should respond_to(:i18n_scope) }
      it { subject.i18n_scope.should eq(:query_filters) }
    end
  end
end
