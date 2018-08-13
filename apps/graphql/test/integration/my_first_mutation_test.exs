defmodule MyFirstMutationTest do
  use GraphqlWeb.ConnCase
  require Graphql.TestHelpers

  # this is important to ensure a clean db between each test
  setup do
    DB.reset_db()
    :ok
  end

  describe "Creating an address" do
    test "It creates a new address in the database", %{conn: conn} do
      # double check the address db is empty before we begin
      assert DB.all(Address) == {:ok, []}

      mutation = """
      mutation createAddress($input: AddressInput) {
        createAddress(input: $input) {
          id
          postcode
          houseNumber
        }
      }
      """

      variables = """
      {
        "input": {
          "postcode": "SW1A 1AA",
          "houseNumber": 1
        }
      }
      """

      conn
      |> Graphql.TestHelpers.make_graphql_mutation(mutation, variables)

      {:ok, [address]} = DB.all(Address)

      assert address.postcode == "SW1A 1AA"
      assert address.house_number == 1
    end

    test "the graphql response contains an id, postcode and house number", %{conn: conn} do
      mutation = """
      mutation createAddress($input: AddressInput) {
        createAddress(input: $input) {
          id
          postcode
          houseNumber
        }
      }
      """

      variables = """
      {
        "input": {
          "postcode": "SW1A 1AA",
          "houseNumber": 1
        }
      }
      """

      res = Graphql.TestHelpers.make_graphql_mutation(conn, mutation, variables)

      assert res["data"]["createAddress"]["houseNumber"] == 1
      assert res["data"]["createAddress"]["postcode"] == "SW1A 1AA"
      assert not is_nil(res["data"]["createAddress"]["id"])
    end
  end
end
