Sequel.migration do
  change do
    create_table(:search_results) do
      primary_key :tweet_id
      String :user_name, null: false
      Integer :followers, null: false
      Integer :reply_tweet_id
    end
  end
end