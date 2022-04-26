class ProfileQuery
  delegate :call, to: :new

  def initialize(initial_scope)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = filter_user(@initial_scope, params[:current_user])
    scoped = sort(scoped, params[:sort_type], params[:sort_column])
    scoped
  end

  private
  def filter_user(scoped, user)
    scoped.where(user_id: user.id)
  end

  def sort(scoped, sort_type, sort_column)
    sort_type ? scoped.order(sort_column => sort_type) : scoped
  end
end
