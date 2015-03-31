require 'rails_helper'

describe Admin::StaffMembersController do
  let(:params_hash) { attributes_for(:staff_member) }

  describe '#create' do
    example '職員一覧ページにリダイレクト' do
      post :create, staff_member: params_hash
      expect(response).to redirect_to(admin_staff_members_url)
    end

    example '例外 ActionController::ParameterMissing が発生' do
      bypass_rescue
      expect { post :create }.
        to raise_error(ActionController::ParameterMissing)
    end
  end
end
