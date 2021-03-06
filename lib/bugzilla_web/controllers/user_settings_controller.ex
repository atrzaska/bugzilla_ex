defmodule BugzillaWeb.UserSettingsController do
  use BugzillaWeb, :controller

  alias Bugzilla.Accounts
  alias BugzillaWeb.UserAuth
  alias Bugzilla.Mailer

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update_email(conn, %{"current_password" => password, "user" => user_params}) do
    user = conn.assigns.user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &Routes.user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your e-mail change has been sent to the new address."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.user, token) do
      :ok ->
        conn
        |> put_flash(:info, "E-mail changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  def update_password(conn, %{"current_password" => password, "user" => user_params}) do
    user = conn.assigns.user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.user

    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Updated successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", personal_changeset: changeset)
    end
  end

  def delete(conn, _params) do
    user = conn.assigns.user

    Accounts.delete_user(user)
    Mailer.deliver_delete_account_confirmation(user)

    conn
    |> put_flash(:info, "Your account have been deleted.")
    |> UserAuth.log_out_user()
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.user

    conn
    |> assign(:personal_changeset, Accounts.change_personal_data(user))
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end
end
