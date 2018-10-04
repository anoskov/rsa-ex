defmodule RsaEx do
  alias RsaEx.RSAPrivateKey

  @type private_key :: String.t
  @type public_key :: String.t

  @doc """
  Generates RSA private key of {bits} size. Default is 2048.
      iex> {:ok, priv} = RsaEx.generate_private_key("4096")
  """
  @spec generate_private_key :: {atom, private_key}
  def generate_private_key(bits \\ "2048") do
    private_key = "ExPrivateKey.pem"
    {_, 0} = System.cmd "openssl", [ "genrsa", "-out", private_key, bits], [stderr_to_stdout: true]
    {:ok, priv} = File.read(private_key)
    File.rm!(private_key)

    {:ok, priv}
  end

  @doc """
  Generates RSA public key
      iex> {:ok, priv} = RsaEx.generate_private_key
      iex> {:ok, pub} = RsaEx.generate_public_key(priv)
  """
  @spec generate_public_key(private_key) :: {atom, public_key}
  def generate_public_key(private_key) do
    private_key_name = "ExPrivateKey.pem"
    public_key_name = "ExPublicKey.pem"
    File.write("./#{private_key_name}", private_key)
    {_, 0} = System.cmd "openssl",
     [ "rsa", "-pubout", "-in" , private_key_name, "-out", public_key_name ], [stderr_to_stdout: true]
    {:ok, pub} = File.read(public_key_name)

    File.rm!(private_key_name)
    File.rm!(public_key_name)

    {:ok, pub}
  end

  @doc """
  Generates RSA private/public keypair of {bits} size. Default is 2048.
      iex> {:ok, {priv, pub}} = RsaEx.generate_keypair("4096")
  """
  @spec generate_keypair :: {atom, {private_key, public_key}}
  def generate_keypair(bits \\ "2048") do
    private_key_name = "ExPrivateKey.pem"
    public_key_name = "ExPublicKey.pem"

    {_, 0} = System.cmd "openssl", [ "genrsa", "-out", private_key_name, bits], [stderr_to_stdout: true]
    {_, 0} = System.cmd "openssl",
      [ "rsa", "-pubout", "-in" , private_key_name, "-out", public_key_name ], [stderr_to_stdout: true]
    {:ok, priv} = File.read(private_key_name)
    {:ok, pub} = File.read(public_key_name)

    File.rm!(private_key_name)
    File.rm!(public_key_name)

    {:ok, {priv, pub}}
  end

  @doc """
  Sign message with RSA private key
      iex> {:ok, signature} = RsaEx.sign(message, rsa_private_key)
      {:ok, <<...>>}
  """
  @spec sign(String.t, private_key, atom) :: {atom, binary}
  def sign(message, private_key, digest_type \\ :sha256) do
    {:ok, priv_key} = loads(private_key)
    {:ok, priv_key_seq} = RSAPrivateKey.as_sequence(priv_key)
    {:ok, :public_key.sign(message, digest_type, priv_key_seq)}
  end

  @doc """
  Verify signature with RSA public key
      iex> {:ok, valid} = RsaEx.verify(message, signature, rsa_public_key
      {:ok, true}
  """
  @spec verify(String.t, binary, public_key, atom) :: {atom, boolean}
  def verify(message, signature, public_key, digest_type \\ :sha256) do
    {:ok, pub_key} = loads(public_key)
    {:ok, pub_key_seq} = RsaEx.RSAPublicKey.as_sequence(pub_key)
    {:ok, :public_key.verify(message, digest_type, signature, pub_key_seq)}
  end

  @doc """
  Encrypt message with RSA public key in base64
      iex> clear_text = "Important message"
      "Important message"
      iex> {:ok, cipher_text} = RsaEx.encrypt(clear_text, {:public_key, rsa_public_key})
      {:ok, "Lmbv...HQ=="}
  """
  @spec encrypt(String.t, {:public_key, public_key}) :: {atom, String.t}
  def encrypt(message, {:public_key, public_key}) do
    {:ok, pub_key} = loads(public_key)
    {:ok, pub_key_seq} = RsaEx.RSAPublicKey.as_sequence(pub_key)
    {:ok, :public_key.encrypt_public(message, pub_key_seq)} |> url_encode64
  end

  @doc """
  Encrypt message with RSA private key in base64
      iex> clear_text = "Important message"
      "Important message"
      iex> {:ok, cipher_text} = RsaEx.encrypt(clear_text, {:private_key, rsa_private_key})
      {:ok, "Lmbv...HQ=="}
  """
  @spec encrypt(String.t, {:private_key, private_key}) :: {atom, String.t}
  def encrypt(message, {:private_key, private_key}) do
    {:ok, priv_key} = loads(private_key)
    {:ok, priv_key_seq} = RsaEx.RSAPrivateKey.as_sequence(priv_key)
    {:ok, :public_key.encrypt_private(message, priv_key_seq)} |> url_encode64
  end

  @doc """
  Decrypt message with RSA private key
      iex(8)> {:ok, decrypted_clear_text} = RsaEx.decrypt(cipher_text, rsa_private_key)
      {:ok, "Important message"}
  """
  @spec decrypt(String.t, {:private_key, private_key}) :: {atom, String.t}
  def decrypt(cipher_msg, {:private_key, private_key}) do
    {:ok, cipher_bytes} = Base.url_decode64(cipher_msg)
    {:ok, priv_key} = loads(private_key)
    {:ok, priv_key_seq} = RSAPrivateKey.as_sequence(priv_key)
    {:ok, :public_key.decrypt_private(cipher_bytes, priv_key_seq)}
  end

  ### Internal functions

  defp loads(pem_string) do
    pem_entries = :public_key.pem_decode(pem_string)
      validate_pem_length(pem_entries)
      |> load_pem_entry
      |> sort_key_tup
  end

  defp load_pem_entry({:ok, pem_entry}) do
    load_pem_entry(pem_entry)
  end
  defp load_pem_entry(pem_entry) do
    {:ok, :public_key.pem_entry_decode(pem_entry)}
  end

  defp validate_pem_length(pem_entries) do
    case length(pem_entries) do
      0 -> {:error, "invalid argument"}
      x when x > 1 -> {:error, "found multiple PEM entries, expected only 1"}
      x when x == 1 -> {:ok, Enum.at(pem_entries, 0)}
    end
  end

  defp sort_key_tup({:ok, key_tup}) do
    sort_key_tup(key_tup)
  end
  defp sort_key_tup(key_tup) do
    case elem(key_tup, 0) do
      :RSAPrivateKey ->
        {:ok, RsaEx.RSAPrivateKey.from_sequence(key_tup)}
      :RSAPublicKey ->
        {:ok, RsaEx.RSAPublicKey.from_sequence(key_tup)}
      x ->
        {:error, "invalid argument, expected one of[ExPublicKey.RSAPublicKey, ExPublicKey.RSAPrivateKey], found: #{x}"}
    end
  end

  defp url_encode64({:ok, bytes_to_encode}) do
    url_encode64(bytes_to_encode)
  end
  defp url_encode64(bytes_to_encode) do
    {:ok, Base.url_encode64(bytes_to_encode)}
  end
end
