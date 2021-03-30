import io
import math
import datetime
from flask import Blueprint, render_template, request, redirect, url_for, flash, send_file
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from app import mysql

PER_PAGE = 10
bp = Blueprint('films', __name__, url_prefix='/films')

@bp.route('/films')
def logs():
    page = request.args.get('page', 1, type=int)
    with mysql.connection.cursor(named_tuple = True) as cursor:
        cursor.execute('SELECT count(*) AS count FROM exam_films;')
        total_count = cursor.fetchone().count
    total_pages = math.ceil(total_count/PER_PAGE)
    pagination_info = {
        'current_page' : page,
        'total_pages' : total_pages,
        'per_page' : PER_PAGE
    }
    query = '''
    SELECT exam_films.id, exam_films.name, genre.name, exam_films.prod_year, exam_films.count(review) from exam_films, genre
    
    '''
    cursor = mysql.connection.cursor(named_tuple=True)
    cursor.execute(query, (PER_PAGE, PER_PAGE*(page+1)))
    records = cursor.fetchall()
    cursor.close()
    return render_template('/films.html', records = records, pagination_info = pagination_info)