require 'base64'

class UsersController < ApplicationController

  skip_before_action :authorize_request, only: [:create]

  # POST /signup
  # return authenticated token upon signup
  def create
    user = User.find_by(email: user_params['email'])
    if !user
      dataToRegister = {
          username: user_params['username'],
          balance: user_params['balance'],
          password: Base64.decode64(user_params['password']),
          password_confirmation: Base64.decode64(user_params['password_confirmation']),
          email: user_params['email'],
      }
      user = User.create!(dataToRegister)
      auth_token = AuthenticateUser.new(user.email, Base64.encode64(user.password)).call
      response = {
        data: {
          message: Message.account_created,
          token: auth_token,
          user: {
              username: user.username,
              email: user.email
          }
        }
      }
      json_response(response, :created)

    else
      raise(ExceptionHandler::AuthenticationError, Message.email_Already_used)
    end
  end

  def addFunds
    current_user['balance'] += user_params['moneyToAdd']
    current_user.save
    json_response(current_user)
  end

  def removeFunds
    newBalance = current_user['balance'] - user_params['moneyToRetire']
    if newBalance >= 0
      current_user['balance'] = newBalance
      current_user.save
      json_response(current_user);
    else
      raise(ExceptionHandler::NotEnoughMoney, Message.not_enough_money)
    end
  end

  def info
    response = {
        userName: current_user.username,
        email: current_user.email,
        balance: current_user.balance
    }
    json_response(response)
  end

  private

  def user_params
    params.permit(
        :username,
        :email,
        :balance,
        :password,
        :password_confirmation,
        :moneyToRetire,
        :moneyToAdd
    )
  end

end
