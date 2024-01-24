def insert_member(cursor,name,email,tall,birthday):
    sql = """
            INSERT INTO member(name,email,tall,birthday)
            VALUES (%s,%s,%s,%s,NOW())"""
    return cursor.execute(sql,name,email,tall,birthday)

def update_member2(cursor,*args):
    print(args)
    print(type(args))
    # sql = """
    #         UPDATE member
    #         SET name=%s
    #             ,email=%s
    #             ,tall=%s
    #             ,birthday=%s
    #         WHERE id = %s"""
    # return cursor.execute(sql,args)

def update_member(cursor,id,name,email,tall,birthday):
    sql = """
            UPDATE member
            SET name=%s
                ,email=%s
                ,tall=%s
                ,birthday=%s
            WHERE id = %s"""
    return cursor.execute(sql,(name,email,tall,birthday,id))

def delete_member(cursor,id):
    sql = """
            DELETE FROM member
            WHERE id = %s"""
    return cursor.execute(sql,id)

def select_members(cursor):
    sql = """
            SELECT *
            FROM member"""
    cursor.execute(sql)
    return cursor.fetchall()

def select_member_by_id(cursor,id):
    sql = """
            SELECT *
            FROM member
            WHERE id = %s"""
    cursor.execute(sql,id)
    return cursor.fetchone()
