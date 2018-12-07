# -*- coding: utf-8 -*-

import os
import sys, traceback, time

from sqlalchemy import create_engine
from sqlalchemy import text

# configurar el motor de sqlalchemy
db_engine = create_engine("postgresql://alumnodb:alumnodb@localhost/si1", echo=False, execution_options={"autocommit":False})

def dbConnect():
    return db_engine.connect()

def dbCloseConnect(db_conn):
    db_conn.close()

def getListaCliMes(db_conn, mes, anio, iumbral, iintervalo, use_prepare, break0, niter):



    if use_prepare == True:
    
        q =  text( """PREPARE getListaCliMes(int, int, int) AS
                 SELECT COUNT(DISTINCT customerid) as cc
                 FROM orders
                 WHERE totalamount > $1 
                       AND EXTRACT (YEAR FROM orderdate) = $2 
                       AND EXTRACT (MONTH FROM orderdate) = $3; """ )       

        db_conn.execute(q)

    else:

        q = text(
                    "SELECT COUNT(DISTINCT customerid) as cc FROM orders WHERE totalamount > :bound AND EXTRACT (YEAR FROM orderdate) = :year AND EXTRACT (MONTH FROM orderdate) = :month;"
                )

    # Array con resultados de la consulta para cada umbral
    dbr=[]

    for ii in range(niter):

        if use_prepare == True:

            q = text("EXECUTE getListaCliMes(%s, %s, %s); " %(iumbral, anio, mes))
            res = db_conn.execute(q).fetchall()[0]

        else:

            res = db_conn.execute(q, bound = iumbral, year = anio, month = mes).fetchall()[0]

        # Guardar resultado de la query
        dbr.append({"umbral":iumbral,"contador":res['cc']})

        if break0 ==  True and res['cc'] == 0:

            if use_prepare == True:

                q = text("DEALLOCATE getListaCliMes;")
                db_conn.execute(q)


            return dbr
        
        # Actualizacion de umbral
        iumbral = iumbral + iintervalo


    if use_prepare == True:

        q = text("DEALLOCATE getListaCliMes;")
        db_conn.execute(q)

                
    return dbr

def getMovies(anio):
    # conexion a la base de datos
    db_conn = db_engine.connect()

    query="select movietitle from imdb_movies where year = '" + anio + "'"
    resultproxy=db_conn.execute(query)

    a = []
    for rowproxy in resultproxy:
        d={}
        # rowproxy.items() returns an array like [(key0, value0), (key1, value1)]
        for tup in rowproxy.items():
            # build up the dictionary
            d[tup[0]] = tup[1]
        a.append(d)
        
    resultproxy.close()  
    
    db_conn.close()  
    
    return a
    
def getCustomer(username, password):
    # conexion a la base de datos
    db_conn = db_engine.connect()

    query="select * from customers where username='" + username + "' and password='" + password + "'"
    res=db_conn.execute(query).first()
    
    db_conn.close()  

    if res is None:
        return None
    else:
        return {'firstname': res['firstname'], 'lastname': res['lastname']}
    
def delCustomer(customerid, bFallo, bSQL, duerme, bCommit):
    
    # Array de trazas a mostrar en la página
    dbr=[]

    # TODO: Ejecutar consultas de borrado
    # - ordenar consultas según se desee provocar un error (bFallo True) o no
    # - ejecutar commit intermedio si bCommit es True
    # - usar sentencias SQL ('BEGIN', 'COMMIT', ...) si bSQL es True
    # - suspender la ejecución 'duerme' segundos en el punto adecuado para forzar deadlock
    # - ir guardando trazas mediante dbr.append()
    
    try:
        # TODO: ejecutar consultas
        pass

    except Exception as e:
        # TODO: deshacer en caso de error
        pass

    else:
        # TODO: confirmar cambios si todo va bien
        pass
        
    return dbr


