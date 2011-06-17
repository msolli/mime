# encoding: utf-8

namespace :mime do

  namespace :migrate do
    
    desc "Migrerer bilder fra Media til Image"
    task :medias => :environment do
      Article.all.each do |article|
        next if (!article.respond_to?(:media_ids)) || article.media_ids.blank?
        Rails.logger.info "*** Article: #{article.headword}"
        article.media_ids.each do |m_id|
          begin
            m = Media.find(m_id)
          rescue Mongoid::Errors::DocumentNotFound
            Rails.logger.info "###### Could not find Media #{m_id}"
            next
          end
          Rails.logger.info "****** Creating Image #{m_id}"
          i = Image.create(m.attributes.except("article_ids").merge({author: "Ukjent"}))
          i.articles << article
        end
        Rails.logger.info "*** Deleting media_ids collection"
        article.collection.update({ "_id" => article.id }, { "$unset" => { "media_ids" => 1 }})
      end
    end
  end
end
