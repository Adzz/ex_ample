defmodule MySecondQueryTest do
  use GraphqlWeb.ConnCase
  require Graphql.TestHelpers

  # this is important to ensure a clean db between each test
  setup do
    DB.delete_all(LandRegData)
    :ok
  end

  describe "queries for the field successfully" do
    test "Queries for average_time_to_sold (in days) successfully", %{conn: conn} do
      {:ok, record} = DB.create(LandRegData, %{id: "10", average_time_to_sold: 6_000_000})

      query = "query landRegQuery($id: ID!){
        getLandRegData(id: $id) { averageTimeToSold }
      }"

      variables = """
      {
        "id": "#{record.id}"
      }
      """

      res =
        conn
        |> Graphql.TestHelpers.make_graphql_query(query, variables)

      assert res["data"] == %{"getLandRegData" => %{"averageTimeToSold" => 6_000_000}}
    end
  end
end
