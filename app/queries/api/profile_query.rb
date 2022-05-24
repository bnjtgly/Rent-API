class ProfileQuery
  # delegate :call, to: :new
  attr_accessor :initial_scope

  def initialize(initial_scope)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = filter_user(@initial_scope, params[:current_user], params[:include_table])
    scoped = sort(scoped, params[:sort_type], params[:sort_column])
    scoped
  end

  private
  def filter_user(scoped, user, include_table)
    include_table ? scoped.where(include_table => {user_id: user.id}) : scoped.where(user_id: user.id)
  end

  def sort(scoped, sort_type, sort_column)
    sort_type ? scoped.order(sort_column => sort_type) : scoped
  end
end
