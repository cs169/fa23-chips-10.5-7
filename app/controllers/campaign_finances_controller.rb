class CampaignFinancesController < ApplicationController
  def index
    @election_cycle_options = (2010..2020).map { |year| [year.to_s, year] }
    categories = [
      'Candidate Loan',
      'Contribution Total',
      'Debts Owed',
      'Disbursements Total',
      'End Cash',
      'Individual Total',
      'PAC Total',
      'Receipts Total',
      'Refund Total'
    ]
    @category_options = categories.map { |category| [category, category] }
  end

  def search
    @candidates = CampaignFinance.top_candidates(params[:cycle], params[:category])
    render :show
  end
end
