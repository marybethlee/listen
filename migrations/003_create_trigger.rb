Sequel.migration do
  up do
    run <<~SQL
      create trigger comment_added
      after insert
      on comments
      for each row
      execute procedure notify_comments();
    SQL
  end

  down do
    run <<~SQL
      drop trigger comment_added
      on comments;
    SQL
  end
end
