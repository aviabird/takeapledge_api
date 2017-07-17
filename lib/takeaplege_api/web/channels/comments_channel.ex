defmodule TakeaplegeApi.Web.CommentsChannel do
  use TakeaplegeApi.Web, :channel

  def join("comments:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (comments:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def broadcast_create(comment) do
    payload = TakeaplegeApi.Web.CommentView.render("comment.json", %{comment: comment})
    TakeaplegeApi.Web.Endpoint.broadcast("comments:lobby", "new:msg", payload)
  end

  def broadcast_delete(id) do
    payload = %{id: id}
    TakeaplegeApi.Web.Endpoint.broadcast("comments:lobby", "delete:msg", payload)
  end
end
