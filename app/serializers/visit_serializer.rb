class VisitSerializer < Blueprinter::Base
  fields :id, :ip_address, :user_agent, :created_at
end
