class TransactionController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :destroy]

  # GET /transaction
  def index
    @transactions = current_user.transactions
    json_response(@transactions)
  end

  # POST /transaction
  def create
    userToAdd = User.find(transaction_params['destination'])
    if userToAdd
      if current_user.balance > transaction_params['transferred']
        @transaction = current_user.transactions.create!(transaction_params)
        @income = {
            transaction_id: @transaction['id'],
            totalIncome: @transaction['comission'] + @transaction['rate']
        }
        Income.create!(@income)
        userToAdd.balance += @transaction['transferred']
        userToAdd.save
        json_response(@transaction, :created)
      else
        raise(ExceptionHandler::NotEnoughMoney, Message.not_enough_money)
      end
    else
      raise(ExceptionHandler::AuthenticationError, Message.invalid_account)
    end
  end

  # GET /transaction/:id
  def show
    json_response(@transaction)
  end

  # PUT /transaction/:id
  def update
    @transaction.update(transaction_params)
    head :no_content
  end

  # DELETE /transaction/:id
  def destroy
    @transaction.destroy
    head :no_content
  end

  private

  def transaction_params
    # whitelist params
    params.permit(:transferred, :comission, :rate, :total, :destination)
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

end
