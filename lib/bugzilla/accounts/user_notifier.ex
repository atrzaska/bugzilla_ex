defmodule Bugzilla.Accounts.UserNotifier do
  alias Bugzilla.Mailer

  def deliver_welcome_email(user) do
    Mailer.deliver_welcome_email(user)
  end

  def deliver_confirmation_instructions(user, url) do
    Mailer.deliver_confirmation_instructions(user, url)
  end

  def deliver_reset_password_instructions(user, url) do
    Mailer.deliver_reset_password_instructions(user, url)
  end

  def deliver_update_email_instructions(user, url) do
    Mailer.deliver_update_email_instructions(user, url)
  end
end
