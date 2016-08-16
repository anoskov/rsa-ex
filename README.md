# RSA Ex

Library for working with RSA keys using Elixir and OpenSSL ports.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

* Add `rsa_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:rsa_ex, "~> 0.1.0"}]
end
```

* Ensure `rsa_ex` is started before your application:

```elixir
def application do
  [applications: [:rsa_ex]]
end
```

## Usage

* Generate RSA 2048 Private Key

```elixir
iex> {:ok, priv} = RsaEx.generate_private_key
```

* Generate RSA 2048 Public Key

```elixir
iex> {:ok, priv} = RsaEx.generate_private_key
iex> {:ok, pub} = RsaEx.generate_public_key(priv)
```

* Generate RSA 2048 Private/Public Keypair

```elixir
iex> {:ok, {priv, pub}} = RsaEx.generate_keypair
```
* Sign message with RSA private key

```elixir
iex> {:ok, rsa_private_key} = RsaEx.generate_private_key
iex> {:ok, signature} = RsaEx.sign("message", rsa_private_key)
```
