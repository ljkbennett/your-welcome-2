Sequel.migration do
  change do
    create_table(:search_results) do
      primary_key :id
      Bignum :tweet_id
      String :user_name, null: false
      Integer :followers, null: false
      Boolean :reply_sent, default: false

      index :tweet_id
    end
  end
end