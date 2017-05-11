defmodule Annon.Plugins.MonitoringTest do
  @moduledoc false
  use Annon.UnitCase

  setup do
    :sys.replace_state DogStat, fn state ->
      Map.update!(state, :sink, fn _prev_state -> [] end)
    end
  end

  test "metrics work properly" do
    api = Annon.ConfigurationFactory.insert(:api, %{
      name: "Montoring Test api",
      request: Annon.ConfigurationFactory.build(:api_request, %{host: "www.example.com", path: "/apis"})
    })

    Annon.ConfigurationFactory.insert(:proxy_plugin, %{
      name: "proxy",
      is_enabled: true,
      api: api,
      settings: %{
        scheme: "http",
        host: "localhost",
        port: 4040,
        path: "/apis"
      }
    })

    call_public_router("/apis")

    [%{header: [_, "test", 46], key: "latencies_gateway",
       options: [tags: ["http_status:200", "http_host:www.example.com",
         "http_method:GET", "http_port:80", "api_name:Montoring Test api",
         "api_id:" <> _,
         "request_id:" <> _], sample_rate: 1],
       type: :histogram, value: _},
     %{header: [_, "test", 46], key: "latencies_upstream",
       options: [tags: ["http_status:200", "http_host:www.example.com",
         "http_method:GET", "http_port:80", "api_name:Montoring Test api",
         "api_id:" <> _,
         "request_id:" <> _], sample_rate: 1],
       type: :histogram, value: _},
     %{header: [_, "test", 46], key: "latencies_client",
       options: [tags: ["http_status:200", "http_host:www.example.com",
         "http_method:GET", "http_port:80", "api_name:Montoring Test api",
         "api_id:" <> _,
         "request_id:" <> _], sample_rate: 1],
       type: :histogram, value: _},
     %{header: [_, "test", 46], key: "request_count",
       options: [tags: ["http_host:www.example.com", "http_method:GET",
         "http_port:80", "api_name:Montoring Test api",
         "api_id:" <> _,
         "request_id:" <> _], sample_rate: 1],
       type: :counter, value: "1"}] = sent()
  end

  defp sent(name \\ DogStat),
    do: state(name).sink

  defp state(name),
    do: :sys.get_state(name)
end
