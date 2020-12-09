import psycopg2

class DataBase:
    def __init__(self):
        self.connect = psycopg2.connect(dbname='memes', user='postgres', 
                                        password='zdes mogla bit vasha reklama', host='localhost')
        self.cursor = self.connect.cursor()
    
    def __del__(self):
        self.cursor.close()
        self.connect.close()

    
    def __new__(cls):
        if not hasattr(cls, 'instance'):
            cls.instance = super(DataBase, cls).__new__(cls)
        return cls.instance


    def printQuery(self):
        queryData = self.cursor.fetchall()

        if queryData is None:
            print("None query data")
        else:
            for row in queryData:
                print(row)

    def checkTableExist(self, name):
        self.cursor.execute('''
            SELECT * FROM information_schema.tables
            WHERE table_schema = 'public' AND
            table_name = '{name}'
        '''.format(name=name))

        existName = self.cursor.fetchone()

        if existName is not None:
            return True
        
        return False
    

    '''01 Scalar query'''
    def getReviewByDate(self, date):
        self.cursor.execute('''
            SELECT login, public_date 
            FROM account
            JOIN review
            ON review.author_id = account.account_id
            WHERE date_part('year', public_date) = 
        ''' + date)
    
    '''02 Some JOIN query'''
    def getTagsPicturePng(self):
        self.cursor.execute('''
            SELECT tag_name, picture_path 
            FROM picture 
	        JOIN tag_to_picture 
            ON tag_to_picture.picture_id = picture.picture_id
	        JOIN tag 
            ON tag_to_picture.tag_id = tag.tag_id
            WHERE picture_path LIKE '%.png';
        ''')
    
    '''03 Query with OTB or Window'''
    def getUsersWithoutReviews(self):
        self.cursor.execute('''
            WITH not_rating_post AS 
            (
	            SELECT author_id, title, public_date FROM post
	            WHERE NOT EXISTS
	            (
		            SELECT post_id FROM review
		            WHERE review.post_id = post.post_id
	            )
            )

            SELECT login, title, public_date FROM not_rating_post
            JOIN account 
            ON account.account_id = not_rating_post.author_id
        ''')
    
    '''04 Query to metadata'''
    def getTables(self):
        self.cursor.execute('''
            SELECT table_name, table_type
            FROM information_schema.tables
            WHERE table_schema = 'public'
        ''')
    
    '''05 Call scalar function'''
    def getPostCount(self):
        self.cursor.callproc('get_number_post')
        self.connect.commit()
    
    '''06 Call multi-operator or table function'''
    def getUserLoginByID(self, id):
        self.cursor.callproc('get_login', [id])
        self.connect.commit()

    '''07 Call procedure'''
    def getConstraints(self):
        self.cursor.execute('Call get_metadata()')
        
        for notice in self.connect.notices[:-1]:
            print(notice)

    '''08 Call system function or procedure'''
    def getVersion(self):
        self.cursor.callproc('version')
    
    '''09 Create table'''
    def createTable(self, name):
        tableExist = self.checkTableExist(name)

        if tableExist:
            print('>>> Table with name - {name} already exist\n'.format(name=name))
        else:
            try:
                self.cursor.execute('''
                    CREATE TABLE {name}
                    (
                        id          SERIAL  PRIMARY KEY,
                        role        VARCHAR NOT NULL,
                        rating_buf  INTEGER NOT NULL
                    )
                '''.format(name=name))

                print('>>> Table {name} successfully created\n'.format(name=name))

            except psycopg2.OperationalError:
                print('>>> Table creation denied by postgresql\n')

    '''Drop new table (not on assignment)'''
    def dropTable(self, name):
        tableExist = self.checkTableExist(name)

        if not tableExist:
            print('>>> Table {name} not exist\n'.format(name=name))
        else:
            try:
                self.cursor.execute('''
                    DROP TABLE {name}
                '''.format(name=name))
                print('>>> Table {name} successfully drop\n'.format(name=name))

            except psycopg2.OperationalError:
                print('>>> Table drop denied by postgresql\n')

    '''10 Insert data into the created table using INSERT or COPY statements.'''
    def insertNewData(self, nameDB, role, rating_buf):
        tableExist = self.checkTableExist(nameDB)

        if not tableExist:
            print('>>> Table {name} not exist\n'.format(name=nameDB))
        else:
            try:
                self.cursor.execute('''
                    INSERT INTO {name} (role, rating_buf) 
                    VALUES (%s, %s)
                '''.format(name=nameDB), [role, rating_buf])
                print('>>> Insert into {name} successfully\n'.format(name=nameDB))

            except psycopg2.OperationalError:
                print('>>> Insert denied by postgresql\n')