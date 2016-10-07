class Dump < ActiveRecord::Base
  serialize :tables, Array
  belongs_to :user
  
  after_create :prepare

  def ready?
    status.to_sym == :ready
  end


  def prepare
    logger.info "[Dump#perpare] Prepare dump ##{id}"
    
    dirname = "#{RAILS_ROOT}/dump/#{Time.now.strftime('%Y%m%d%H%M%S')}"
    archive = Archive.write_open_filename(dirname + '.tar.gz', Archive::COMPRESSION_GZIP, Archive::FORMAT_TAR)
    FileUtils.mkdir_p(dirname)
    tables.each do |table|

      logger.info "[Dump#perpare] Dump table #{table}"
      filename = "#{table}.csv"
      path = dirname + '/' + filename;
      FasterCSV.open(path, 'w') do |csv|
        csv << connection.select_values("SHOW FIELDS FROM #{table}")
        connection.select_rows("SELECT * FROM #{table}").each do |row|
          csv << row
        end
      end
      archive.new_entry do |entry|
        entry.pathname = filename
        entry.copy_stat(path)
        archive.write_header(entry)
        archive.write_data(open(path) {|f| f.read })
      end
    end
    FileUtils.rm_f dirname
    archive.close
    update_attributes(:status => 'ready', :filename => dirname + '.tar.gz')
    Mail.deliver_dump_ready(self)
  end
#  handle_asynchronously :prepare
end
