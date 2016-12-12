defmodule RsaEx.Mixfile do
  use Mix.Project

  def project do
    [app: :rsa_ex,
     version: "0.2.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases(),
     description: description(),
     package: package()]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp aliases do
    []
  end

  defp description do
    "Library for working with RSA keys."
  end

  defp package do
    [name: :rsa_ex,
     files: ["lib", "mix.exs"],
     maintainers: ["Andrey Noskov"],
     licenses: ["MIT"],
     links: %{"github" => "https://github.com/anoskov/rsa-ex"}]
  end
end
