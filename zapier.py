import psycopg2
import config

#Connecting to Zapier DB
def connect(dbname):  
    if dbname != config.db_redshift['dbname']:
        raise ValueError('could not find DB with given name')
    
    conn = psycopg2.connect(host=config.db_redshift['host'],
                            user=config.db_redshift['user'],
                            password=config.db_redshift['password'],
                            dbname=config.db_redshift['dbname'],
                            port=config.db_redshift['port'])
    return conn

#close DB connection
def close_connection(cursor, connection):
    
    l = [cursor, connection]
    
    for c in l:
        c.close()
    
def execute_sql_script(cur,fn):
    # Open and read the file as a single buffer
    fd = open(fn, 'r')
    sql_file = fd.read()
    fd.close()
    
    # split sql commands to execute them 1 by 1 - helps identify if one single fails
    sql_comm = sql_file.split(';')

    # execute commands from the file
    for command in sql_comm:
        try:
            cur.execute(command)
            print('SQL command executed with success.');
        except:
            print('The following SQL command failed: {0} \n\nFrom the file: {1}'.format(command, fn))

def main():
    
    conn = connect('zapier')
    cur = conn.cursor()
    
    cur.execute("SET search_path TO " + config.db_redshift['write_perms_schema'])
    
    #sql file for etl processing
    fn = 'zap_etl.sql'
    execute_sql_script(cur,fn)
    
    #commit end of all operations, if successfull
    conn.commit()
    
    # Close the connection
    close_connection(cur, conn)
    
    print('Execution finished.')

if __name__ == '__main__':
    main()

