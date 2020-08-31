defmodule Bugzilla.Email do
  use Bamboo.Phoenix, view: BugzillaWeb.EmailView

  def welcome(user) do
    base_email(user)
    |> subject("Welcome to Bugzilla")
    |> render("welcome.html")
    |> premail()
  end

  def confirmation(user, url) do
    base_email(user)
    |> assign(:url, url)
    |> subject("Confirm email")
    |> render("confirmation.html")
    |> premail()
  end

  defp base_email(user) do
    new_email()
    |> to(user.email)
    |> from("noreply@bugzilla.app")
    |> put_header("Reply-To", "noreply@bugzilla.app")
    |> put_html_layout({BugzillaWeb.LayoutView, "email.html"})
    |> put_text_layout(false)
    |> to(user.email)
    |> assign(:user, user)
  end

  defp premail(email) do
    html = Premailex.to_inline_css(email.html_body)
    text = Premailex.to_text(email.html_body)

    email
    |> html_body(html)
    |> text_body(text)
  end
end
