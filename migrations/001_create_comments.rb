Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      String :body, null: false
    end
  end
end
