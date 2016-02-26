require 'csv'

class AllocationsController < AuthenticatedController
  api :GET, '/allocations?group_id=', 'Get allocations for a particular group'
  def index
    group = Group.find(params[:group_id])
    render json: group.allocations
  end

  api :POST, '/allocations/upload?group_id='
  def upload
    file = params[:csv].tempfile
    parsed_csv = CSV.read(file)
    group = Group.find(params[:group_id])
    AllocationService.create_allocations_from_csv(parsed_csv: parsed_csv, group: group, current_user: current_user)
    
    if errors =
      render json: {errors: errors}, status: 409
    else
      render nothing: true, status: 200
    end
  end

  api :POST, '/allocations?membership_id&amount'
  def create
    group = Group.find(allocation_params[:group_id])
    render status: 403, nothing: true and return unless current_user.is_admin_for?(group)

    allocation = Allocation.new(allocation_params)
    if allocation.save
      render json: [allocation], status: 201
    else
      render status: 400, nothing: true
    end
  end

  private
    def allocation_params
      params.require(:allocation).permit(:group_id, :user_id, :amount)
    end
end
