# encoding: utf-8

namespace :mime do

  namespace :migrate do
    
    desc "Migrerer bilder fra Media til Image"
    task :medias, [] => [:environment] do
      Article.all.each do |article|
        next if !article.respond_to?(:media_ids) || article.media_ids.blank?

        Rails.logger.debug "# Processing medias for article '#{article.headword}'"
        article.media_ids.each do |m_id|
          begin
            m = Media.find(m_id)
          rescue Mongoid::Errors::DocumentNotFound
            Rails.logger.debug "## Could not find Media #{m_id}"
            next
          end
          Rails.logger.debug "## Creating Image #{m_id}"
          i = Image.create(m.attributes.except("article_ids").merge({author: "Ukjent"}))
          Rails.logger.debug "## Adding image to article"
          i.articles << article
          Rails.logger.debug "## Deleting Media #{m_id}"
          m.destroy
        end
      end

      Rails.logger.debug "# Deleting media_ids collection for all articles"
      Article.collection.update({ "_id" => { "$exists" => true }}, { "$unset" => { "media_ids" => 1 }}, multi: true)

      Rails.logger.debug "# Deleting all Media documents"
      Media.delete_all
    end
  end
end
