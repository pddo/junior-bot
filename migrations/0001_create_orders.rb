Sequel.migration do
  up do
    create_table(:orders) do
      primary_key :id
      String :dish
      String :user
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:orders)
  end
end
