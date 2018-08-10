defmodule SmokeTest do
  use GraphqlWeb.ConnCase
  require Graphql.TestHelpers

  # this is important to ensure a clean db between each test
  setup do
    DB.reset_db()
    :ok
  end

  test "Queries the smoke test isThisThingOn successfully", %{conn: conn} do
    query = "{ isThisThingOn }"

    res =
      conn
      |> Graphql.TestHelpers.make_graphql_query(query)

    assert res["data"] == %{"isThisThingOn" => "Yes!"}
  end

  test "Simple echo mutation works correctly", %{conn: conn} do
    mutation = """
    mutation updateEmail($input: String){
      echo_text(input: $input)
    }
    """

    variables = """
    { "input": "test" }
    """

    res =
      conn
      |> Graphql.TestHelpers.make_graphql_mutation(mutation, variables)

    assert res["data"] == %{"echo_text" => "test"}
  end
end
