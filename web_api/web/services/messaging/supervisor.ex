defmodule WebApi.MessageSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    amqp_pool_options = [
      {:name, {:local, :amqp_pool}},
      {:worker_module, WebApi.AMQPPool},
      {:size, 5},
      {:max_overflow, 10}
    ]

    children = [
      worker(WebApi.Consumer, []),
      :poolboy.child_spec(:amqp_pool, amqp_pool_options, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
