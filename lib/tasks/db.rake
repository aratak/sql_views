%w(db:schema:load db:structure:load).each do |task_name|
  task task_name => :drop_views
  Rake::Task[task_name].enhance do
    Rake::Task["db:create_views"].invoke
  end
end

sql_views = ::SqlViews::View.instance

task "db:migrate" do
  sql_views.drop_views
end

Rake::Task["db:migrate"].enhance do
  sql_views.create_views
end

db_namespace = namespace :db do

  task :_create_views_ruby do
    sql_views.create_views
  end

  task :_drop_views_ruby do
    sql_views.drop_views
  end

  task :_create_views_sql do
    begin
      old_env, ENV['RAILS_ENV'] = ENV['RAILS_ENV'], 'test'
      sql_views.create_views
    ensure
      ENV['RAILS_ENV'] = old_env
    end
  end

  task :_drop_views_sql do
    begin
      old_env, ENV['RAILS_ENV'] = ENV['RAILS_ENV'], 'test'
      sql_views.drop_views
    ensure
      ENV['RAILS_ENV'] = old_env
    end
  end

  task :create_views => [:environment, :load_config] do
    case ActiveRecord::Base.schema_format
      when :ruby
        db_namespace["_create_views_ruby"].invoke
      when :sql
        db_namespace["_create_views_sql"].invoke
    end
  end

  task :drop_views => [:environment, :load_config] do
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
    ActiveRecord::Schema.verbose = false
    case ActiveRecord::Base.schema_format
      when :ruby
        db_namespace["_drop_views_ruby"].invoke
      when :sql
        db_namespace["_drop_views_sql"].invoke
    end
  end

end
