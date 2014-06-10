require 'spec_helper'
require 'riveter/spec_helper'

describe <%= class_name %>CommandController do
  render_views

  # This should return the minimal set of attributes required to create a valid
  # <%= class_name %>Command. As you add validations to <%= class_name %>Command, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # <%= class_name %>CommandController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET '<%= new_action %>'" do
    it "assigns the command" do
      get :<%= new_action %>, {}, valid_session
      assigns(:command).should eq(<%= class_name %>Command.new())
    end

    it "renders the '<%= new_action %>' template" do
      get :<%= new_action %>, {}, valid_session
      response.should render_template(:<%= new_action %>)
    end
  end

  describe "POST '<%= create_action %>'" do
    describe "with valid params" do
      it "assigns the command" do
        post :<%= create_action %>, {:<%= file_name %> => valid_attributes}, valid_session
        assigns(:command).should eq(<%= class_name %>Command.new())
      end

      it "invokes the associated service object" do
        post :<%= create_action %>, {:<%= file_name %> => valid_attributes}, valid_session

        pending
      end

      it "invokes the on_success callback" do
        post :<%= create_action %>, {:<%= file_name %> => valid_attributes}, valid_session
        pending
      end

      # TODO: complete specification for on success logic
      it "on_success (redirects to ...)" do
        post :<%= create_action %>, {:<%= file_name %> => valid_attributes}, valid_session
        # response.should redirect_to(...)
        pending
      end
    end

    describe "with invalid params" do
      it "assigns the command" do
        allow_any_instance_of(<%= class_name %>Command).to receive(:valid?) { false }
        post :<%= create_action %>, {:<%= file_name %> => {}}, valid_session
        assigns(:command).should eq(<%= class_name %>Command.new())
      end

      it "re-renders the 'new' template" do
        allow_any_instance_of(<%= class_name %>Command).to receive(:valid?) { false }
        post :<%= create_action %>, {:<%= file_name %> => {}}, valid_session
        response.should render_template(:<%= new_action %>)
      end
    end
  end

end
