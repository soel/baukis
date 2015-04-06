require 'rails_helper'

RSpec.describe StaffMember, :type => :model do
  describe '#password=' do
    example '文字列を与えると、 hashed_password は長さ 60 の文字列になる' do
      member = StaffMember.new
      member.password = 'baukis'
      expect(member.hashed_password).to be_kind_of(String)
      expect(member.hashed_password.size).to eq(60)
    end

    example 'nil を与えると、 hashed_password は nil になる' do
      member = StaffMember.new(hashed_password: 'x')
      member.password = nil
      expect(member.hashed_password).to be_nil
    end
  end

  describe '値の正規化' do
    example 'email 前後の空白の除去' do
      member = create(:staff_member, email: ' test@example.com ')
      expect(member.email).to eq('test@example.com')
    end

    example 'email に含まれる全角英数字記号を半角に変換' do
      member = create(:staff_member, email: 'ｔｅｓｔ＠ｅｘａｍｐｌｅ．ｃｏｍ')
      expect(member.email).to eq('test@example.com')
    end

    example 'email 前後の全角スペースを除去' do
      member = create(:staff_member, email: "\u{3000}test@example.com\u{3000}")
      expect(member.email).to eq('test@example.com')
    end

    example 'family_name_kana に含まれるひらがなをカタカナに変換' do
      member = create(:staff_member, family_name_kana: 'てすと')
      expect(member.family_name_kana).to eq('テスト')
    end

    example 'family_name_kana に含まれる半角カナを全角カナに変換' do
      member = create(:staff_member, family_name_kana: 'ﾃｽﾄ')
      expect(member.family_name_kana).to eq('テスト')
    end
  end

  describe 'バリデーション' do
    example '@ を2個含む email は無効' do
      member = build(:staff_member, email: 'test@@example.com')
      expect(member).not_to be_valid
    end

    example '記号を含む family_name は無効' do
      member = build(:staff_member, family_name: '試験★')
      expect(member).not_to be_valid
    end

    example '漢字を含む family_name_kana は無効' do
      member = build(:staff_member, family_name_kana: '試験')
      expect(member).not_to be_valid
    end

    example '調音付を含む family_name_kana は有効' do
      member = build(:staff_member, family_name_kana: 'エリー')
      expect(member).to be_valid
    end

    example '他の職員のメールアドレスと重複した email は無効' do
      member1 = create(:staff_member)
      member2 = build(:staff_member, email: member1.email)
      expect(member2).not_to be_valid
    end
  end
end
