module Paginable
  extend ActiveSupport::Concern

  protected

  def paginate(scope)
    scope.page(params[:page]).per(page_size(scope.klass)).tap { |result| apply_headers(result) }
  end

  private

  def apply_headers(paginated)
    response.headers['X-Total-Count'] = paginated.total_count.to_s
    response.headers['X-Total-Pages'] = paginated.total_pages.to_s
    response.headers['X-Current-Page'] = paginated.current_page.to_s
  end

  def page_size(model)
    value = params[:per_page].to_i
    return value if value.positive?

    model.default_per_page
  end
end
