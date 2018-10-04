defmodule RsaEx.RSATest do
  use ExUnit.Case, async: true

  test "generate_private_key() generates string" do
    {:ok, priv} = RsaEx.generate_private_key

    assert is_binary(priv)
  end

  test "generate_private_key(\"4096\") generates bigger string" do
    {:ok, priv_2048} = RsaEx.generate_private_key
    {:ok, priv_4096} = RsaEx.generate_private_key("4096")

    assert String.length(priv_2048) < String.length(priv_4096)
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

  test "sign(msg, priv_key, dygest_type) generates binary" do
    {:ok, priv} = RsaEx.generate_private_key
    {:ok, signature} = RsaEx.sign("message", priv, :sha512)

    assert is_binary(signature)
  end

  test "verify(msg, signature, pub_key) generates true if valid" do
    {:ok, priv} = RsaEx.generate_private_key
    {:ok, pub} = RsaEx.generate_public_key(priv)
    {:ok, signature} = RsaEx.sign("message", priv)
    {:ok, valid} = RsaEx.verify("message", signature, pub)

    assert valid
  end

  test "verify(msg, signature, pub_key, digest_type) generates true if valid" do
    {:ok, priv} = RsaEx.generate_private_key
    {:ok, pub} = RsaEx.generate_public_key(priv)
    {:ok, signature} = RsaEx.sign("message", priv, :sha512)
    {:ok, valid} = RsaEx.verify("message", signature, pub, :sha512)

    assert valid
  end

  test "verify(msg, signature, pub_key) generates false if invalid" do
    {:ok, priv} = RsaEx.generate_private_key
    {:ok, pub} = RsaEx.generate_public_key(priv)
    {:ok, signature} = RsaEx.sign("message", priv)
    {:ok, invalid} = RsaEx.verify("messages", signature, pub)

    assert invalid == false
  end

  test "verify(msg, signature, pub_key, digest_type) generates false if invalid" do
    {:ok, priv} = RsaEx.generate_private_key
    {:ok, pub} = RsaEx.generate_public_key(priv)
    {:ok, signature} = RsaEx.sign("message", priv, :sha512)
    {:ok, invalid} = RsaEx.verify("messages", signature, pub, :sha512)

    assert invalid == false
  end

  test "encrypt(message, pub_key) generates encrypted string" do
    {:ok, {_priv, pub}} = RsaEx.generate_keypair
    {:ok, encrypted} = RsaEx.encrypt("msg", {:public_key, pub})

    assert is_binary(encrypted)
  end

  test "decrypt(cipher, priv_key) generates decoded string" do
    {:ok, {priv, pub}} = RsaEx.generate_keypair
    {:ok, encrypted} = RsaEx.encrypt("msg", {:public_key, pub})
    {:ok, decrypted} = RsaEx.decrypt(encrypted, priv)

    assert is_binary(decrypted)
    assert decrypted == "msg"
  end
end
