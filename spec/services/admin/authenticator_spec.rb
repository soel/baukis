require 'rails_helper'

describe Admin::Authenticator do
  describe '#authenticate' do
    example '正しいパスワードなら ture を返す' do
      m = build(:administrator)
      expect(Admin::Authenticator.new(m).authenticate('pw')).to be_truthy
    end

    example '誤ったパスワードなら false を返す' do
      m = build(:administrator)
      expect(Admin::Authenticator.new(m).authenticate('xy')).to be_falsey
    end

    example 'パスワード未設定なら false を返す' do
      m = build(:administrator, password: nil)
      expect(Admin::Authenticator.new(m).authenticate(nil)).to be_falsey
    end

    example '停止フラグが立っていても true を返す' do
      m = build(:administrator, suspended: true)
      expect(Admin::Authenticator.new(m).authenticate('pw')).to be_truthy
    end
  end
end
