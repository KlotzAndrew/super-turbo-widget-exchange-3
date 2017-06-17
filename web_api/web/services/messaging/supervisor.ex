defmodule WebApi.MessageSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    amqp_pool_options = [
      {:name, {:local, :amqp_pool}},
      {:worker_module, WebApi.AMQPPool},
      {:size, 2},
      {:max_overflow, 0}
    ]

    children = [
      worker(WebApi.Consumer, []),
      worker(WebApi.RequestConsumer, []),
      worker(WebApi.RandomSender, []),
      :poolboy.child_spec(:amqp_pool, amqp_pool_options, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
