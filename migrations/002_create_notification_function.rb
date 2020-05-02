Sequel.migration do
  up do
    run <<~SQL
      create or replace function notify_comments()
      returns trigger as $$

      begin
        perform pg_notify(
          'comments',
          row_to_json(NEW)::text
        );
        return null;
      end;

      $$ language plpgsql;
    SQL
  end

  down do
    run <<~SQL
      drop function notify_comments();
    SQL
  end
end
