module SqlViews

  class View
    include Singleton

    attr_accessor :filepaths
    attr_accessor :filenames

    def initialize
      @filepaths = Dir[::Rails.root.join('db', 'views', '*')]
      @filenames = @filepaths.map { |filepath| Pathname.new(filepath).basename('.sql').to_s.scan(/\d+_(.+)/).flatten.first }
      ignore_tables
    end

    def ignore_tables
      ActiveRecord::SchemaDumper.ignore_tables.push *filenames
    end

    def create_views
      announce "Create sql views"
      filepaths.each do |filepath|
        ActiveRecord::Base.connection.execute File.read(filepath)
      end
    end

    def drop_views
      filenames.each do |filename|
        announce "Drop sql view", filename
        ActiveRecord::Base.connection.execute "DROP VIEW IF EXISTS `#{filename}`"
      end
    end

    private

    def announce(type, name=nil)
      text = "#{type}: #{name}"
      length = [0, 75 - text.length].max
      puts "== %s %s" % [text, "=" * length]
    end

  end

end
