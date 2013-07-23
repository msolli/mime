require 'spec_helper'

describe ManualArticleListsController do
  
  context "as an editor" do
    login_editor

    describe "#create" do
      it "saves the list to page" do
        page = Factory(:page)
        post :create, manual_article_list: Factory.attributes_for(:manual_article_list), page_id: page.id
        response.should redirect_to(edit_page_path(page))
        assigns(:page).manual_article_lists.should_not be_empty
      end

      it "finds referenced articles for embedded list articles" do
        page = Factory :page
        list = Factory.build(:todays_articles)
        list_attributes = list.attributes
        list_attributes['list_articles_attributes'] = {}
        list.list_articles.each_with_index do |a, i|
          article_attrs = a.attributes
          article_attrs.delete('_id')
          list_attributes['list_articles_attributes'][i] = article_attrs
        end
        post :create, manual_article_list: list_attributes, page_id: page.id
        assigns(:page).manual_article_lists.first.current_articles.first.article.should_not be_blank
      end
    end
  
    describe "#update" do
      it "saves the list to page" do
        page = Factory(:page)
        list = Factory(:todays_articles)
        page.manual_article_lists << list
        put :update, id: list._id, page_id: page._id, manual_article_list: { name: "Nytt navn" }
        response.should redirect_to(edit_page_path(page))
        assigns(:page).manual_article_lists.first.name.should == "Nytt navn"
      end
    end
  end
end
