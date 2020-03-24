defmodule Wasmdome.Wascap.Test do
    use ExUnit.Case
    alias Wasmdome.Wascap

    test "Properly decodes a JWT" do
        jwt = "eyJ0eXAiOiJqd3QiLCJhbGciOiJFZDI1NTE5In0.eyJqdGkiOiJtdmJ0eDZsU2RpRm9CQjNnWmU3UmR1IiwiaWF0IjoxNTg0OTkyMDAzLCJpc3MiOiJPQVdFVFBCNFE2N01PT0ZNUDVZTlhZQlEzUE0zSzJWWFlEVVZLVUcyQU9MUlI1RTc0SjNDSVhBSiIsInN1YiI6IkFDT0pKTjZXVVA0T0RENzVYRUJLS1RDQ1VKSkNZNVpLUTU2WFZLWUs0QkVKV0dWQU9PUUhaTUNXIiwid2FzY2FwIjp7Im5hbWUiOiJ3YVNDQyBPZmZpY2lhbCIsInZhbGlkX3NpZ25lcnMiOltdfX0.wFQ6_t6wGQ9NmE-uRRgOUAo2b18MlDHUAquHpoXyT5WKDdPNct5uRYhD-1zV4q7Is5bjGjYPRhnf7NCEsmCtBA"

        {:ok , decoded} = Wascap.decode_jwt(jwt)            
        assert "OAWETPB4Q67MOOFMP5YNXYBQ3PM3K2VXYDUVKUG2AOLRR5E74J3CIXAJ" = decoded.issuer
        assert "ACOJJN6WUP4ODD75XEBKKTCCUJJCY5ZKQ56XVKYK4BEJWGVAOOQHZMCW" =decoded.subject
        assert "waSCC Official" = decoded.name 
    end

    test "Validate a good JWT" do
        jwt = "eyJ0eXAiOiJqd3QiLCJhbGciOiJFZDI1NTE5In0.eyJqdGkiOiJtdmJ0eDZsU2RpRm9CQjNnWmU3UmR1IiwiaWF0IjoxNTg0OTkyMDAzLCJpc3MiOiJPQVdFVFBCNFE2N01PT0ZNUDVZTlhZQlEzUE0zSzJWWFlEVVZLVUcyQU9MUlI1RTc0SjNDSVhBSiIsInN1YiI6IkFDT0pKTjZXVVA0T0RENzVYRUJLS1RDQ1VKSkNZNVpLUTU2WFZLWUs0QkVKV0dWQU9PUUhaTUNXIiwid2FzY2FwIjp7Im5hbWUiOiJ3YVNDQyBPZmZpY2lhbCIsInZhbGlkX3NpZ25lcnMiOltdfX0.wFQ6_t6wGQ9NmE-uRRgOUAo2b18MlDHUAquHpoXyT5WKDdPNct5uRYhD-1zV4q7Is5bjGjYPRhnf7NCEsmCtBA"

        {:ok, validation} = Wascap.validate_jwt(jwt)
        refute validation.cannot_use_yet
        refute validation.expired
        assert "never" = validation.expires_human
        assert "immediately" = validation.not_before_human
        assert validation.signature_valid
    end
end