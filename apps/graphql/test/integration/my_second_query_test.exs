defmodule MySecondQueryTest do
  use GraphqlWeb.ConnCase
  require Graphql.TestHelpers

  # this is important to ensure a clean db between each test
  setup do
    DB.reset_db()
    :ok
  end

  test "Queries for average_time_to_sold (in days) successfully", %{conn: conn} do
    {:ok, address} = DB.create(Address, postcode: "N35 7ED", house_number: 123)

    {:ok, land_reg_data} =
      DB.create(LandRegData, %{address_id: address.id, average_time_to_sold: 420})

    query = "query landRegQuery($addressId: ID!){
        landRegData(addressId: $addressId) { averageTimeToSold }
      }"

    variables = """
    {
      "addressId": "#{address.id}"
    }
    """

    res =
      conn
      |> Graphql.TestHelpers.make_graphql_query(query, variables)

    assert res["data"] == %{
             "landRegData" => [%{"averageTimeToSold" => land_reg_data.average_time_to_sold}]
           }
  end
end
