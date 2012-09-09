# SqlViews

Library which adds SQL Views to Rails.


## Installation

Add this line to your application's Gemfile:

    gem 'sql_views'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sql_views

## Usage

1. Create folder 'veiws' into '#{Rails.root}/db'.
2. Add `XXX_view_name.sql` file into db/views folder. Where `XXX` - serial number. Remember, that some views can depend on another views. Timestamp is a bad idea, because it's a not migrations, and you can't refactor views inside the file. One file - one view creating.
3. Put into `XXX_view_name.sql` sql script which creating sql view. Something like this:

``` sql

CREATE VIEW view_name AS
SELECT
  `fossil_versions`.root_id AS demand_id,
  `fossil_versions`.root_type AS demand_type,
  `fossil_versions`.changer_id AS changer_id,
  `fossil_versions`.created_at AS created_at,
  `fossil_versions`.updated_at AS updated_at,
  `fossil_versions`.request_id AS request_id,
  `fossil_versions`.company_id AS company_id,
  GROUP_CONCAT(DISTINCT(`fossil_versions`.action)) AS actions,
  (COUNT(DISTINCT(`fossil_versions`.action)) = 1
      AND
      MIN(`fossil_versions`.action) = 'destroy') AS is_destroy,
  (COUNT(DISTINCT(`fossil_versions`.action)) = 1
      AND
      MIN(`fossil_versions`.action) = 'create') AS is_create,
  (SUM(`fossil_versions`.action = 'update' AND `fossil_versions`.column_name != 'state') > 0
      AND
      SUM(`fossil_versions`.column_name = 'state') > 0) AS is_state_and_update,
  (COUNT(DISTINCT(`fossil_versions`.column_name)) = 1
      AND
      MIN(`fossil_versions`.column_name) = 'state') AS is_state,
  (COUNT(DISTINCT(`fossil_versions`.column_name)) = 1
      AND
      MIN(`fossil_versions`.column_name) = 'comment') AS is_comment,
  (SUM(`fossil_versions`.action = 'update') > 0) AS is_update,
  (MAX(IF(`fossil_versions`.column_name = 'comment',`fossil_versions`.change_to,NULL))) AS comment,
  (MAX(IF(`fossil_versions`.column_name = 'state',`fossil_versions`.change_to,NULL))) AS state
FROM `fossil_versions`
GROUP BY
  demand_id,
  demand_type,
  changer_id,
  request_id

```

4. Run rake task "db:migrate". Each time, before this task all views will be destroyed and after db:migrate -- re-created.
5. Views are not added to schema.rb or structure.sql.

## DOTO

1. Tests
2. Create class `ActiveSqlView::Base` for inheritance instead of `ActiveRecord::Base` with redonly patching.
2. Generator of new migration with `rails generate sqlview view_name`
2. Add dependency from the migration, instead of always re-creating views
3. Implement into schema.rb views section
4. Back sql views to structure.sql

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
