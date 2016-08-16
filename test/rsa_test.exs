defmodule RsaEx.RSATest do
  use ExUnit.Case, async: true

  test "generate_private_key() generates string" do
    {:ok, priv} = RsaEx.generate_private_key

    assert is_binary(priv)
  end

  test "generate_public_key(private) generates string" do
    {:ok, priv} = RsaEx.generate_private_key
    {:ok, pub} = RsaEx.generate_public_key(priv)

    assert is_binary(pub)
  end

  test "generate_keypair() generates two string" do
    {:ok, {priv, pub}} = RsaEx.generate_keypair

    assert is_binary(priv)
    assert is_binary(pub)
  end

  test "sign(msg, priv_key) generates binary" do
    {:ok, priv} = RsaEx.generate_private_key
    {:ok, signature} = RsaEx.sign("message", priv)

    assert is_binary(signature)
  end

  test "verify(msg, signature, pub_key) generates true if valid" do
    {:ok, priv} = RsaEx.generate_private_key
    {:ok, pub} = RsaEx.generate_public_key(priv)
    {:ok, signature} = RsaEx.sign("message", priv)
    {:ok, valid} = RsaEx.verify("message", signature, pub)

    assert valid
  end

  test "verify(msg, signature, pub_key) generates false if invalid" do
    {:ok, priv} = RsaEx.generate_private_key
    {:ok, pub} = RsaEx.generate_public_key(priv)
    {:ok, signature} = RsaEx.sign("message", priv)
    {:ok, invalid} = RsaEx.verify("messages", signature, pub)

    assert invalid == false
  end

  test "encrypt(message, pub_key) generates string" do
    {:ok, {_priv, pub}} = RsaEx.generate_keypair
    {:ok, encrypted} = RsaEx.encrypt("msg", pub)

    assert is_binary(encrypted)
  end
end
