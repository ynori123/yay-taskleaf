require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }
  
  before do
    visit login_path
    fill_in 'session[email]', with: login_user.email
    fill_in 'session[password]', with: login_user.password
    click_button 'ログインする'
  end
  shared_examples 'ユーザーAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしている時' do
      let(:login_user) { user_a }

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end

    context 'ユーザーBがログインしている時' do
      let(:login_user) { user_b }
      
      it 'ユーザーAが作成したタスクが表示されない' do
        # 作成済みのタスクの名称が画面上に表示されていることを確認
        expect(page).to have_no_content '最初のタスク'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしている時' do
      let(:login_user) { user_a }

      before do
        
        click_on '最初のタスク'
        page.save_screenshot 'hoge.png'
      end

      it 'ユーザーAが作成したタスクが表示される' do
        expect(page).to have_content '最初のタスク'
      end
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }

    before do
      click_on '新規登録'
      fill_in 'task[name]', with: task_name
      click_button '登録する'
    end

    context '新規作成画面で名称を入力したとき' do
      let(:task_name) { '新規作成のテストを書く' }

      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
      end
    end
    
    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }

      it '名前なしとなる' do
        expect(page).to have_selector '.alert-success', text: '名前なし'
      end
    end
  end
end
