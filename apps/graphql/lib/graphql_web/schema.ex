defmodule Graphql.Schema do
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)

  object :address do
    field(:id, non_null(:id))
    field(:postcode, :string)
    field(:house_number, :integer)
  end

  object :land_reg_data do
    field(:address_id, :id)
    field(:average_time_to_sold, :integer)
  end

  input_object :address_input do
    # fields for dayz
  end

  query do
    field :is_this_thing_on, type: :string do
      resolve(&Graphql.Resolver.smoke_test/2)
    end

    field :get_addresses, type: list_of(:address) do
      resolve(&Graphql.Resolver.addresses/2)
    end

    field :land_reg_data, type: list_of(:land_reg_data) do
      arg(:address_id, non_null(:id))
      resolve(&Graphql.Resolver.land_reg_data/2)
    end
  end

  mutation do
    # stuff goes here.. but which stuff?

    field :echo_text, type: :string do
      arg(:input, :string)
      resolve(&Graphql.Resolver.test_update/2)
    end
  end
end
