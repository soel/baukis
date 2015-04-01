require 'rails_helper'

describe Admin::StaffMembersController, 'ログイン前' do
  it_behaves_like 'a protected admin controller'
end

describe Admin::StaffMembersController do
  let(:params_hash) { attributes_for(:staff_member) }
  let(:administrator) { create(:administrator) }

  before do
    session[:administrator_id] = administrator.id
    session[:last_access_time] = 1.second.ago
  end

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

  describe '#update' do
    let(:staff_member) { create(:staff_member) }

    example 'suspended フラグをセットする' do
      params_hash.merge!(suspended: true)
      patch :update, id: staff_member.id, staff_member: params_hash
      staff_member.reload
      expect(staff_member).to be_suspended
    end

    example 'hashed_password の値の書き換え付加' do
      params_hash.delete(:password)
      params_hash.merge!(hashed_password: 'x')
      expect {
        patch :update, id: staff_member.id, staff_member: params_hash
      }.not_to change { staff_member.hashed_password.to_s }
    end
  end
end
