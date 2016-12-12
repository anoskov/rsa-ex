# RSA Ex

Library for working with RSA keys using Elixir and OpenSSL ports.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

* Add `rsa_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:rsa_ex, "~> 0.1"}]
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

* Generate RSA 4096 Public Key

```elixir
iex> {:ok, priv} = RsaEx.generate_private_key("4096")
iex> {:ok, pub} = RsaEx.generate_public_key(priv)
```

* Generate RSA 2048 Private/Public Keypair

```elixir
iex> {:ok, {priv, pub}} = RsaEx.generate_keypair
```

* Generate RSA 4096 Private/Public Keypair

```elixir
iex> {:ok, {priv, pub}} = RsaEx.generate_keypair("4096")
```

* Sign message with RSA private key

```elixir
iex> {:ok, rsa_private_key} = RsaEx.generate_private_key
iex> {:ok, signature} = RsaEx.sign("message", rsa_private_key)
```

* Verify signature with RSA public key

```elixir
iex> {:ok, valid} = RsaEx.verify(message, signature, rsa_public_key)
```

* Encrypt message with RSA public key in base64

```elixir
iex> clear_text = "Important message"
"Important message"
iex> {:ok, cipher_text} = RsaEx.encrypt(clear_text, rsa_public_key)
{:ok, "Lmbv...HQ=="}
```

* Decrypt message with RSA private key

```elixir
iex> {:ok, decrypted_clear_text} = RsaEx.decrypt(cipher_text, rsa_private_key)
{:ok, "Important message"}
```
