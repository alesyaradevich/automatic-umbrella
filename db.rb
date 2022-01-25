class DB
    def initialize
      begin
        @con = PG.connect :dbname=> 'my_db', :user=> 'ubuntu', :password=>'rfgjgjhe27'
      rescue
        # Ignored
      end
    end

    def create_tables
      begin
        @con.exec('CREATE TABLE IF NOT EXISTS public.users1
                   (
                     userid SERIAL NOT NULL,
                     email character varying(30) NOT NULL,
                     nickname character varying(30) NOT NULL,
                     CONSTRAINT users1_pkey PRIMARY KEY (userid),
                     CONSTRAINT users1_email_key UNIQUE (email)
                   )')
      rescue
      end
      begin
        @con.exec('CREATE TABLE IF NOT EXISTS public.users2
                   (
                     userid SERIAL NOT NULL,
                     firstname character varying(30) NOT NULL,
                     lastname character varying(30) NOT NULL,
                     sex character varying(10) NOT NULL,
                     birth_date date,
                     CONSTRAINT fkey FOREIGN KEY (userid)
                     REFERENCES public.users1 (userid)
                   )')
      rescue
      end
      begin
        @con.exec('CREATE TABLE IF NOT EXISTS public.pictures
                  (
                    id SERIAL,
                    url character varying NOT NULL,
                    alttext character varying NOT NULL,
                    CONSTRAINT pictures_pkey PRIMARY KEY (id),
                    CONSTRAINT pictures_url_key UNIQUE (url)
                  )')
      rescue
      # Ignored
      end
      begin
        @con.exec('CREATE TABLE IF NOT EXISTS public.avatars
                  (
                    user_id integer,
                    url character varying NOT NULL,
                    alttext character varying,
                    avatar_id integer NOT NULL,
                    CONSTRAINT avatars_url_key UNIQUE (url)
                  )')
      rescue
      # Ignored
      end
      begin
        @con.exec('CREATE TABLE IF NOT EXISTS public.user_picture
                  (
                    user_id integer NOT NULL,
                    picture_id integer NOT NULL,
                    CONSTRAINT user_picture_pkey PRIMARY KEY (user_id, picture_id),
                    CONSTRAINT fk_picture FOREIGN KEY (picture_id)
                    REFERENCES public.pictures (id),
                    CONSTRAINT fk_user FOREIGN KEY (user_id)
                    REFERENCES public.users1 (userid)
                  )')
      rescue
      # Ignored
      end
    end

    def delete_table_content
      begin
        @con.exec("TRUNCATE users1, users2, pictures, user_picture, avatars CASCADE")
      puts "tables were truncated"
      rescue
      puts "Tables were not truncated."
      end
    end

    def import_csv_to_table(file_path, table_name)
      begin
        @con.exec("COPY #{table_name} FROM '#{file_path}'
               WITH DELIMITER ','")
      rescue
        puts "Information wasn't inserted."
      end
    end

    def select_users
      @con.exec( 'SELECT * from users1
               JOIN users2
               ON users1.userid = users2.userid' )
    end

    def select_avatars
      @con.exec( 'SELECT user_id, nickname, avatar_id, alttext FROM avatars
               JOIN users1
               ON avatars.user_id = users1.userid
               ORDER BY avatars.user_id;' )
    end

    def select_pictures (user_id)
      @con.exec( "SELECT u.userid, p.id, p.alttext
                  FROM users1 AS u
                  INNER JOIN user_picture AS up
                  ON u.userid = up.user_id
                  INNER JOIN pictures AS p
                  ON up.picture_id = p.id
                  WHERE userid = #{user_id}" )

    end
end
