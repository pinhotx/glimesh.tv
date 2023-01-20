defmodule GlimeshWeb.Users.ProfileLive do
  use GlimeshWeb, :user_settings_live_view

  alias Glimesh.Accounts
  alias Glimesh.Accounts.User

  def render(assigns) do
    ~H"""
    <.header>Change Email</.header>

    <.form
      :let={f}
      for={@profile_changeset}
      multipart
      phx-submit="update"
      phx-change="validate"
      class="form"
    >
      <div class="card">
        <div class="card-body">
          <div class="row">
            <div class="col-md-4">
              <div class="text-center">
                <h5 class="mt-4"><%= gettext("Settings") %></h5>
                <img
                  src={Glimesh.Avatar.url({@current_user.avatar, @current_user}, :original)}
                  alt="Your Profile Picture"
                  class="img-fluid mb-4 img-avatar"
                />

                <div class="mb-4 text-left">
                  <p>
                    <%= gettext("Click Update Settings down below when you've chosen the file.") %>
                  </p>
                  <%= file_input(f, :avatar,
                    id: "customFile",
                    class: "",
                    accept: "image/png, image/jpeg"
                  ) %>
                  <%= if f.errors[:avatar] do %>
                    <div>
                      <span class="text-danger">
                        <%= gettext("Invalid image. Must be either png or jpg.") %>
                      </span>
                    </div>
                  <% end %>
                </div>
              </div>
            </div>
            <div class="col-md-8">
              <%= if @profile_changeset.action do %>
                <div class="alert alert-danger">
                  <p style="margin-bottom: 0px;">
                    <%= gettext("Oops, something went wrong! Please check the errors below.") %>
                  </p>
                </div>
              <% end %>

              <div class="row">
                <div class="col-sm-6">
                  <h5 class=""><%= gettext("Settings") %></h5>
                  <div class="form-group">
                    <%= label(f, gettext("Display Name")) %>
                    <%= text_input(f, :displayname, class: "form-control") %>
                    <%= error_tag(f, :displayname) %>
                  </div>
                </div>
                <div class="col-sm-6">
                  <h5><%= gettext("Pronoun Settings") %></h5>
                  <div class="form-group">
                    <%= label(f, gettext("Preferred Pronoun")) %>
                    <%= select(f, :pronoun, @pronouns, class: "form-control") %>
                    <%= error_tag(f, :pronoun) %>
                  </div>

                  <span><%= gettext("Display Pronoun:") %></span>
                  <div class="custom-control custom-checkbox">
                    <%= checkbox(f, :show_pronoun_stream, class: "custom-control-input") %>
                    <%= label(f, :show_pronoun_stream, gettext("On Channel"),
                      class: "custom-control-label"
                    ) %>
                    <%= error_tag(f, :show_pronoun_stream) %>
                  </div>

                  <div class="custom-control custom-checkbox">
                    <%= checkbox(f, :show_pronoun_profile, class: "custom-control-input") %>
                    <%= label(f, :show_pronoun_profile, gettext("On Profile"),
                      class: "custom-control-label"
                    ) %>
                    <%= error_tag(f, :show_pronoun_profile) %>
                  </div>
                </div>
              </div>

              <div class="info">
                <h5 class=""><%= gettext("Social") %></h5>

                <div class="row">
                  <div class="col-md-6">
                    <div
                      class="input-group social-tweet mb-3"
                      id="twitter-container"
                      phx-update="ignore"
                    >
                      <%= if @twitter_account != nil do %>
                        <%= link to: Routes.user_social_path(@socket, :disconnect,  "twitter"), class: "btn btn-danger btn-block", data: [confirm: gettext("Are you sure you want to disconnect your Twitter account?")], method: :delete do %>
                          <i class="fab fa-twitter fa-fw"></i>
                          Disconnect @ <%= @twitter_account.username %>
                        <% end %>
                      <% else %>
                        <a
                          href={@twitter_auth_url}
                          class={["btn btn-info btn-block", unless(@twitter_auth_url, do: "disabled")]}
                        >
                          <i class="fab fa-twitter fa-fw"></i>
                          <%= if f.data.social_twitter do %>
                            Connect @<%= f.data.social_twitter %>
                          <% else %>
                            Connect Twitter Account
                          <% end %>
                        </a>
                      <% end %>
                    </div>
                  </div>

                  <div class="col-md-6">
                    <div class="input-group social-instagram mb-3">
                      <div class="input-group-prepend">
                        <span class="input-group-text" id="instagram">
                          <i class="fab fa-instagram fa-fw"></i>
                        </span>
                      </div>
                      <%= text_input(f, :social_instagram,
                        class: "form-control",
                        placeholder: gettext("Instagram Username")
                      ) %>
                      <%= error_tag(f, :social_instagram) %>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-6">
                    <div class="input-group social-youtube mb-3">
                      <div class="input-group-prepend">
                        <span class="input-group-text" id="fb">
                          <i class="fab fa-youtube fa-fw"></i>
                        </span>
                      </div>
                      <%= text_input(f, :social_youtube,
                        class: "form-control",
                        placeholder: gettext("YouTube Username")
                      ) %>
                      <%= error_tag(f, :social_youtube) %>
                    </div>
                  </div>

                  <div class="col-md-6">
                    <div class="input-group social-discord mb-3">
                      <div class="input-group-prepend">
                        <span class="input-group-text" id="discord">
                          <i class="fab fa-discord fa-fw"></i>
                        </span>
                      </div>
                      <%= text_input(f, :social_discord,
                        class: "form-control",
                        placeholder: gettext("Discord Invite Code")
                      ) %>
                      <%= error_tag(f, :social_discord) %>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-6">
                    <div class="input-group social-guilded mb-3">
                      <div class="input-group-prepend">
                        <span class="input-group-text" id="guilded">
                          <i class="fab fa-guilded fa-fw"></i>
                        </span>
                      </div>
                      <%= text_input(f, :social_guilded,
                        class: "form-control",
                        placeholder: gettext("Guilded Server URL")
                      ) %>
                      <%= error_tag(f, :social_guilded) %>
                    </div>
                  </div>
                </div>
              </div>

              <div class="form-group">
                <%= label(f, :youtube_intro_url, gettext("YouTube Teaser URL")) %>
                <%= text_input(f, :youtube_intro_url,
                  class: "form-control mb-4",
                  placeholder: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
                ) %>
                <%= error_tag(f, :youtube_intro_url) %>
              </div>

              <div class="form-group">
                <label>
                  <%= raw(
                    gettext("Profile Content (%{a_start}Markdown%{a_end} supported)",
                      a_start: "<a href=\"https://www.markdownguide.org/\" target=\"_blank\">",
                      a_end: "</a>"
                    )
                  ) %>
                </label>

                <ul class="nav nav-pills" id="markdown-editor">
                  <li class="nav-item">
                    <a
                      id="edit_button"
                      class="btn btn-primary"
                      phx-click={
                        JS.push("edit_state", value: %{state: "edit"})
                        |> JS.add_class("btn-primary", to: "#edit_button")
                        |> JS.remove_class("btn-info", to: "#preview_button")
                      }
                    >
                      <%= gettext("Edit") %>
                    </a>
                  </li>
                  <li class="nav-item">
                    <a
                      id="preview_button"
                      class="btn ml-2"
                      phx-click={
                        JS.push("edit_state", value: %{state: "preview"})
                        |> JS.add_class("btn-info", to: "#preview_button")
                        |> JS.remove_class("btn-primary", to: "#edit_button")
                      }
                    >
                      <%= gettext("Preview") %>
                    </a>
                  </li>
                </ul>

                <div class="mt-4" id="tab_container">
                  <%= if @markdown_state == "edit" do %>
                    <markdown-toolbar
                      id="profile-content-edit-box"
                      for="textarea_edit"
                      phx-update="ignore"
                    >
                      <div class="d-inline-flex mb-2">
                        <div class="pr-3">
                          <md-bold
                            class="fas fa-bold fa-2x"
                            data-toggle="tooltip"
                            data-placement="top"
                            title={gettext("Bold")}
                          >
                          </md-bold>
                          <md-italic
                            class="fas fa-italic fa-2x"
                            data-toggle="tooltip"
                            data-placement="top"
                            title={gettext("Italic")}
                          >
                          </md-italic>
                          <md-header
                            class="fas fa-heading fa-2x"
                            data-toggle="tooltip"
                            data-placement="top"
                            title={gettext("Heading")}
                          >
                          </md-header>
                        </div>
                        <div class="pr-3 pl-3">
                          <md-quote
                            class="fas fa-quote-right fa-2x"
                            data-toggle="tooltip"
                            data-placement="top"
                            title={gettext("Quote")}
                          >
                          </md-quote>
                          <md-code
                            class="fas fa-code fa-2x"
                            data-toggle="tooltip"
                            data-placement="top"
                            title={gettext("Code")}
                          >
                          </md-code>
                          <md-link
                            class="fas fa-link fa-2x"
                            data-toggle="tooltip"
                            data-placement="top"
                            title={gettext("Link")}
                          >
                          </md-link>
                          <md-image
                            class="fas fa-image fa-2x"
                            data-toggle="tooltip"
                            data-placement="top"
                            title={gettext("Image")}
                          >
                          </md-image>
                        </div>
                        <div class="pr-3 pl-3">
                          <md-unordered-list
                            class="fas fa-list-ul fa-2x"
                            data-toggle="tooltip"
                            data-placement="top"
                            title={gettext("Unordered List")}
                          >
                          </md-unordered-list>
                          <md-ordered-list
                            class="fas fa-list-ol fa-2x"
                            data-toggle="tooltip"
                            data-placement="top"
                            title={gettext("Ordered List")}
                          >
                          </md-ordered-list>
                        </div>
                      </div>
                    </markdown-toolbar>
                    <%= textarea(f, :profile_content_md,
                      class: "form-control mb-4 text-monospace",
                      id: "textarea_edit",
                      rows: 20,
                      phx_change: "update_markdown",
                      value: @raw_markdown
                    ) %>
                  <% else %>
                    <%= raw(@formatted_markdown) %>
                  <% end %>
                </div>

                <%= error_tag(f, :profile_content_md) %>
              </div>

              <%= submit(gettext("Update Settings"), class: "btn btn-primary") %>
            </div>
          </div>
        </div>
      </div>
    </.form>
    """
  end

  def mount(_params, session, socket) do
    user = socket.assigns.current_user

    socket =
      socket
      |> assign(:pronouns, Accounts.Profile.list_pronouns())
      |> assign(:profile_changeset, Accounts.change_user_profile(user))
      |> assign(:twitter_auth_url, session["twitter_auth_url"])
      |> assign(:twitter_account, Glimesh.Socials.get_social(user, "twitter"))
      |> assign(:raw_markdown, user.profile_content_md)
      |> assign(:formatted_markdown, user.profile_content_html)
      |> assign(:markdown_state, "edit")
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    profile_changeset = Accounts.change_user_profile(socket.assigns.current_user, user_params)

    socket =
      assign(socket,
        profile_changeset: Map.put(profile_changeset, :action, :validate) |> dbg()
      )

    {:noreply, socket}
  end

  def handle_event("update", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, put_flash(socket, :info, info)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_changeset, Map.put(changeset, :action, :insert))}
    end
  end

  @impl true
  def handle_event("edit_state", %{"state" => "edit"}, socket) do
    {:noreply, assign(socket, :markdown_state, "edit")}
  end

  def handle_event("edit_state", %{"state" => "preview"}, socket) do
    markdown = socket.assigns.raw_markdown |> Profile.safe_user_markdown_to_html() |> elem(1)

    {:noreply,
     socket
     |> assign(:formatted_markdown, markdown)
     |> assign(:markdown_state, "preview")}
  end

  def handle_event("update_markdown", value, socket) do
    {:noreply, assign(socket, :raw_markdown, value["user"]["profile_content_md"])}
  end
end
