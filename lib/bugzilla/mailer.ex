defmodule Bugzilla.Mailer do
  use Bamboo.Mailer, otp_app: :bugzilla

  alias Bugzilla.Email

  def deliver_welcome_email(user) do
    {:ok, Email.welcome(user) |> deliver_later()}
  end

  def deliver_confirmation_instructions(user, url) do
    {:ok, Email.confirmation(user, url) |> deliver_later()}
  end

  def deliver_reset_password_instructions(user, url) do
    {:ok, Email.reset_password_instructions(user, url) |> deliver_later()}
  end

  def deliver_update_email_instructions(user, url) do
    {:ok, Email.update_email_instructions(user, url) |> deliver_later()}
  end

  def deliver_invitation_email(invite) do
    {:ok, Email.invite(invite) |> deliver_later()}
  end

  def deliver_delete_account_confirmation(user) do
    {:ok, Email.delete_account_confirmation(user) |> deliver_later()}
  end
end
