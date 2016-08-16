defmodule RsaEx do
  @doc """
  Generates RSA 2048 private key
  """
  @spec generate_private_key :: {atom, String.t}
  def generate_private_key do
    private_key = "ExPrivateKey.pem"
    {_, 0} = System.cmd "openssl", [ "genrsa", "-out", private_key, "2048"], [stderr_to_stdout: true]
    {:ok, priv} = File.read(private_key)
    {_, 0} = System.cmd "rm", ["-f", private_key]

    {:ok, priv}
  end
end
