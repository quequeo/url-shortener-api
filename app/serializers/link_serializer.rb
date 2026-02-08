class LinkSerializer < Blueprinter::Base
  fields :id, :original_url, :short_code, :click_count, :created_at
end
