defmodule FlameTest.Application do
  use Application
  import YamlElixir.Sigil

  def start(_type, _args) do
    pod_template = ~y"""
    spec:
      serviceAccountName: flame-test
      containers:
      - imagePullPolicy: Never    
    """
    children = [
      {FLAME.Pool,
        name: FlameTest.TaskRunner,
        backend: {FLAMEK8sBackend, runner_pod_tpl: pod_template},
        min: 0,
        max: 10,
        max_concurrency: 5,
        idle_shutdown_after: 30_000,
        log: :debug
        },
      {Bandit, plug: FlameTest.Router, port: 4000}

    ]

    opts = [strategy: :one_for_one, name: FlameTest.ApplicationSupervisor]
    Supervisor.start_link(children, opts)
  end
end

