require('pg')

class SqlRunner

  def self.run( sql )
    begin
      db = PG.connect({ dbname: 'guppies', host: 'localhost' })
      result = db.exec( sql )
    ensure
      db.close
    end
    return result
  end

#run each sql command to the database
  def self.with_db
    db = PG.connect({ dbname: 'guppies', host: 'localhost' })
    begin
     yield db
   ensure
     db.close
   end
 end

# used in conjunction with - with_do to run an sql file on the database
 def self.reset(fname)
  sql = File.open(fname, 'rb') { |file| file.read }
  SqlRunner.with_db do |db|
    begin
      db.exec(sql)
    rescue PG::Error
       #####
     end
   end
 end
end
