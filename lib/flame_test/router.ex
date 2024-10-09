defmodule FlameTest.Router do
  require Logger
  use Plug.Router

  plug Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason

  plug :match
  plug :dispatch

  post "/call" do
    data = conn.body_params

    result = FLAME.call(FlameTest.TaskRunner, fn ->
      Logger.info("Processed task on node #{inspect(node())}")
      data["data"] * 2
    end)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, ~s({"message": #{result}}))
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
