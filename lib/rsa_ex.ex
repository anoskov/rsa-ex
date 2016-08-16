defmodule RsaEx do

  @type private_key :: String.t
  @type public_key :: String.t

  @doc """
  Generates RSA 2048 private key
  """
  @spec generate_private_key :: {atom, private_key}
  def generate_private_key do
    private_key = "ExPrivateKey.pem"
    {_, 0} = System.cmd "openssl", [ "genrsa", "-out", private_key, "2048"], [stderr_to_stdout: true]
    {:ok, priv} = File.read(private_key)
    {_, 0} = System.cmd "rm", ["-f", private_key]

    {:ok, priv}
  end

  @doc """
  Generates RSA 2048 public key
  """
  @spec generate_public_key(private_key) :: {atom, public_key}
  def generate_public_key(private_key) do
    private_key_name = "ExPrivateKey.pem"
    public_key_name = "ExPublicKey.pem"
    File.write("./#{private_key_name}", private_key)
    {_, 0} = System.cmd "openssl",
     [ "rsa", "-pubout", "-in" , private_key_name, "-out", public_key_name ], [stderr_to_stdout: true]
    {:ok, pub} = File.read(public_key_name)

    {_, 0} = System.cmd "rm", ["-f", private_key_name]
    {_, 0} = System.cmd "rm", ["-f", public_key_name]

    {:ok, pub}
  end
end
