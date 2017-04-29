module DeleteResourceRoute
  def resources(*args, &block)
    super(*args) do
      yield if block_given?
      member do
        get :delete # routes to delete view
        post   :delete, action: :destroy # handles del template form
        delete :delete, action: :destroy # handles JS del on index view
      end
    end
  end
end

ActionDispatch::Routing::Mapper.send(:include, DeleteResourceRoute)
