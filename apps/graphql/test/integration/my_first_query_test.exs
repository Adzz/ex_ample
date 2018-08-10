defmodule MyFirstQueryTest do
  use GraphqlWeb.ConnCase
  require Graphql.TestHelpers

  # this is important to ensure a clean db between each test
  setup do
    DB.reset_db()
    :ok
  end

  describe "queries for all of the addresses successfully" do
    test "Queries for id, postcode and house number", %{conn: conn} do
      {:ok, record} = DB.create(Address, %{house_number: 123, postcode: "N35 7ED"})

      query = "{
        getAddresses {
          id
          postcode
          houseNumber
        }
      }"

      res =
        conn
        |> Graphql.TestHelpers.make_graphql_query(query)

      assert res["data"] == %{
               "getAddresses" => [
                 %{"houseNumber" => 123, "id" => record.id, "postcode" => "N35 7ED"}
               ]
             }
    end
  end
end
