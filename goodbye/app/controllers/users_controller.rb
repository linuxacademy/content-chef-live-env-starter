class UsersController < ApplicationController
  def index
    # Define @users to be listed out on the root page.
    # Data will be shaped something like this (uncomment to see
    # root page render fake data)
    # @users = [
    #   {
    #     "username" => "fake_user",
    #     "email" => "fake_user@example.com",
    #     "display_name" => "Fake User",
    #     "first_name" => "Fake",
    #     "last_name" => "User",
    #     "middle_name" => ""
    #   },
    #   {
    #     "username" => "fake_user2",
    #     "email" => "fake_user@example.com",
    #     "display_name" => "Fake User 2",
    #     "first_name" => "Fake",
    #     "last_name" => "User 2",
    #     "middle_name" => ""
    #   },
    #   {
    #     "username" => "fake_user3",
    #     "email" => "fake_user3@example.com",
    #     "display_name" => "Fake User 3",
    #     "first_name" => "Fake",
    #     "last_name" => "User 3",
    #     "middle_name" => ""
    #   },
    # ]
  end

  def destroy
    # Delete given user using Chef API
    # Username will be passed to action and reachable as `params[:id]`
  end
end
