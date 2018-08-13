defmodule MyFirstResolvingFunctionTest do
  use GraphqlWeb.ConnCase
  require Graphql.TestHelpers

  # this is important to ensure a clean db between each test
  setup do
    DB.reset_db()
    :ok
  end

  test "land reg data can tell me the average sale price for an address", %{conn: conn} do
    {:ok, address} = DB.create(Address, postcode: "N35 7ED", house_number: 123)

    query = "{
        getAddresses {
          id
          formattedAddress
        }
      }"

    res =
      conn
      |> Graphql.TestHelpers.make_graphql_query(query)

    assert res["data"] == %{
             "getAddresses" => [%{"id" => address.id, "formattedAddress" => "123 N35 7ED"}]
           }
  end
end
