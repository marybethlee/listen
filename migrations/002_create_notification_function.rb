Sequel.migration do
  up do
    run <<~SQL
      create or replace function notify_comments()
      returns trigger as $$

      begin
        perform pg_notify(
          'comments',
          json_build_object(
            'event', TG_OP,
            'record', row_to_json(NEW)
          )::text
        );

        return NEW;
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
