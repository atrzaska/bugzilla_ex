defmodule Bugzilla.Accounts.UserNotifier do
  alias Bugzilla.{Email, Mailer}

  def deliver_welcome_email(user) do
    {:ok, Email.welcome(user) |> Mailer.deliver_later()}
  end

  def deliver_confirmation_instructions(user, url) do
    {:ok, Email.confirmation(user, url) |> Mailer.deliver_later()}
  end

  def deliver_reset_password_instructions(user, url) do
    {:ok, Email.reset_password_instructions(user, url) |> Mailer.deliver_later()}
  end

  def deliver_update_email_instructions(user, url) do
    {:ok, Email.update_email_instructions(user, url) |> Mailer.deliver_later()}
  end
end
