defmodule GlimeshWeb.Channel.Components.LivePlayer do
  use GlimeshWeb, :live_component

  attr :channel_id, :integer, required: true
  attr :janus_url, :string, default: ""
  attr :poster, :string, default: "/images/stream-not-started.jpg"
  attr :muted, :boolean, default: false
  attr :status, :string, default: "loading"

  def render(assigns) do
    ~H"""
    <video
      id={@id}
      class="h-full mx-auto video-js vjs-theme-city"
      phx-hook="LivePlayer"
      controls
      playsinline
      poster={@poster}
      muted={@muted}
      data-janus-url={@janus_url}
      data-channel-id={@channel_id}
      data-status={@status}
    >
    </video>
    """
  end
end
