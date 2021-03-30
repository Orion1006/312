import os
from flask import Flask, render_template, request, session, redirect, url_for, flash
from flask_login import login_required, current_user
from mysql_db import MySQL
import mysql.connector as connector
import markdown
import math
import bleach

PER_PAGE = 10

app = Flask(__name__)
application = app
app.secret_key = os.urandom(24)
app.config.from_pyfile("config.py")

mysql = MySQL(app)

from auth import bp as auth_bp, init_login_manager, check_rights

init_login_manager(app)
app.register_blueprint(auth_bp)


def load_roles():
    cursor = mysql.connection.cursor(named_tuple=True)
    cursor.execute("SELECT id,name FROM exam_roles;")
    roles = cursor.fetchall()
    cursor.close()
    return roles


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/films")
def films():
    page = request.args.get("page", 1, type=int)

    for arg in request.args:
        if arg != "page":
            if request.args.get(arg, type=str):
                search[arg] = request.args.get(arg, type=str)

    with mysql.connection.cursor(named_tuple=True) as cursor:
        cursor.execute("SELECT count(*) AS count FROM exam_films;")
        total_count = cursor.fetchone().count
    total_pages = math.ceil(total_count / PER_PAGE)
    pagination_info = {
        "current_page": page,
        "total_pages": total_pages,
        "per_page": PER_PAGE,
    }
    query = """
    SELECT
    exam_films.id,
    exam_films.name,
    exam_films.prod_year,
    GROUP_CONCAT(exam_genre.name) AS genre,
    review_number
    FROM
    exam_films
    INNER JOIN film_genre ON exam_films.id = film_genre.film_id
    INNER JOIN exam_genre ON film_genre.genre_id = exam_genre.id
    JOIN (SELECT count(*) as review_number,film_id from exam_review GROUP BY film_id) as review on exam_films.id = review.film_id
    GROUP BY id
    ORDER BY exam_films.prod_year DESC
    LIMIT %s OFFSET %s;
    """
    cursor = mysql.connection.cursor(named_tuple=True)
    cursor.execute(query, (PER_PAGE, PER_PAGE * (page - 1)))
    films = cursor.fetchall()
    cursor.execute("SELECT id,name from exam_genre")
    genres = cursor.fetchall()
    cursor.execute(
        "SELECT distinct prod_year from exam_films ORDER BY prod_year DESC;")
    prod_years = cursor.fetchall()
    cursor.close()
    return render_template("films/index.html",
                           films=films,
                           pagination_info=pagination_info,
                           genres=genres,
                           prod_years=prod_years)


@app.route("/films/<int:film_id>")
def show(film_id):
    cursor = mysql.connection.cursor(named_tuple=True)
    cursor.execute("SELECT * FROM exam_films WHERE id = %s;", (film_id, ))
    film = cursor.fetchone()
    cursor.execute(
        "SELECT name from exam_genre where id in (SELECT genre_id from film_genre where film_id = %s)",
        (film_id, ))
    genres = cursor.fetchall()
    reviews, review_rating = load_reviews(film_id)
    cursor.execute(
        "SELECT user_id from exam_review where film_id = %s and user_id = %s;",
        (film_id, current_user.id))
    check_review = cursor.fetchone()
    cursor.close()
    return render_template("films/show.html",
                           film=film,
                           genres=genres,
                           reviews=reviews,
                           review_rating=review_rating,
                           check_review=check_review,
                           markdown=markdown.markdown)


@app.route("/films/new")
@login_required
@check_rights("new")
def new():
    return render_template("films/new.html", film={})


@app.route("/films/<int:film_id>/edit")
@login_required
@check_rights("edit")
def edit(film_id):
    cursor = mysql.connection.cursor(named_tuple=True)
    cursor.execute("SELECT * FROM exam_films WHERE id=%s;", (film_id, ))
    film = cursor.fetchone()
    cursor.execute(
        "SELECT name from exam_genre where id in (SELECT genre_id from film_genre where film_id = %s)",
        (film_id, ))
    genres = cursor.fetchall()
    genres = [item.name for item in genres]
    cursor.close()
    return render_template("films/edit.html", film=film, genres=genres)


@app.route("/films/create", methods=["POST"])
@login_required
@check_rights("new")
def create():
    cursor = mysql.connection.cursor(named_tuple=True)
    name = request.form.get("name") or None
    description = request.form.get("description") or None
    country = request.form.get("country") or None
    producer = request.form.get("producer") or None
    screenwriter = request.form.get("screenwriter") or None
    actors = request.form.get("actors") or None
    duration = request.form.get("duration") or None
    prod_year = request.form.get("prod_year") or None
    poster_id = request.form.get("poster_id") or None
    genres = request.form.get("genre") or None
    if genres:
        genres = genres.split()
    try:
        prod_year = int(prod_year)
    except:
        prod_year = None
        flash("Введены некорректная дата. Ошибка сохранения.", "danger")
        film = {
            "name": name,
            "description": description,
            "prod_year": prod_year,
            "country": country,
            "producer": producer,
            "screenwriter": screenwriter,
            "actors": actors,
            "duration": duration,
        }
        return render_template("films/new.html", genres=genres, film=film)
    query = """
        INSERT INTO exam_films (name, description, prod_year, country, producer, screenwriter, actors, duration, poster_id)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s);
    """
    try:
        cursor.execute(query, (
            name,
            description,
            prod_year,
            country,
            producer,
            screenwriter,
            actors,
            duration,
            poster_id,
        ))
    except connector.errors.DatabaseError as err:
        flash("Введены некорректные данные. Ошибка сохранения.", "danger")
        film = {
            "name": name,
            "description": description,
            "prod_year": prod_year,
            "country": country,
            "producer": producer,
            "screenwriter": screenwriter,
            "actors": actors,
            "duration": duration,
        }
        return render_template("films/new.html", genres=genres, film=film)
    for i in range(len(genres)):
        genres[i] = f"'{genres[i]}'"
    cursor.execute(
        "SELECT exam_genre.id from exam_genre WHERE exam_genre.id in (SELECT exam_genre.id from exam_genre where name in (%s));"
        % ",".join(genres))
    genres = cursor.fetchall()
    genres_id = []
    cursor.execute(
        "SELECT exam_films.id from exam_films where exam_films.id = (SELECT max(exam_films.id) FROM exam_films)"
    )
    films = cursor.fetchone()
    film_id = []
    for number in films:
        film_id.append(number)
    for genre in genres:
        genres_id.append(genre.id)
    try:
        for genre in genres_id:
            for film in film_id:
                cursor.execute(
                    "INSERT INTO film_genre (genre_id, film_id) VALUES (%s,%s);",
                    (genre, film))
    except connector.errors.DatabaseError as err:
        flash("Введены некорректные жанры. Ошибка сохранения.", "danger")
        film = {
            "name": name,
            "description": description,
            "prod_year": prod_year,
            "country": country,
            "producer": producer,
            "screenwriter": screenwriter,
            "actors": actors,
            "duration": duration,
        }
        return render_template("films/new.html", genres=genres, film=film)
    mysql.connection.commit()
    cursor.close()
    flash(f"Фильм {name} был успешно создан", "success")
    return redirect(url_for("films"))


@app.route("/films/<int:film_id>/update", methods=["POST"])
@login_required
@check_rights("edit")
def update(film_id):
    cursor = mysql.connection.cursor(named_tuple=True)
    name = request.form.get("name") or None
    description = request.form.get("description") or None
    prod_year = request.form.get("prod_year") or None
    country = request.form.get("country") or None
    producer = request.form.get("producer") or None
    screenwriter = request.form.get("screenwriter") or None
    actors = request.form.get("actors") or None
    duration = request.form.get("duration") or None
    genres = request.form.get("genre") or None
    genres = genres.split()
    for i in range(len(genres)):
        genres[i] = f"'{genres[i]}'"
    cursor.execute(
        "SELECT exam_genre.id from exam_genre WHERE exam_genre.id in (SELECT exam_genre.id from exam_genre where name in (%s));"
        % ",".join(genres))
    genres = cursor.fetchall()
    genres_id = []
    for genre in genres:
        genres_id.append(genre.id)
    query = """
        UPDATE exam_films SET name=%s, description=%s, prod_year=%s, country=%s, producer=%s, screenwriter=%s, actors=%s , duration=%s
        WHERE id=%s; """
    try:
        cursor.execute(
            query,
            (
                name,
                description,
                prod_year,
                country,
                producer,
                screenwriter,
                actors,
                duration,
                film_id,
            ),
        )
    except connector.errors.DatabaseError as err:
        genres = [item.name for item in genres]
        flash("Введены некорректные данные. Ошибка сохранения.", "danger")
        film = {
            "name": name,
            "description": description,
            "prod_year": prod_year,
            "country": country,
            "producer": producer,
            "screenwriter": screenwriter,
            "actors": actors,
            "duration": duration,
            "genres": genres,
        }
        return render_template("films/edit.html", film=film)
    cursor.execute(
        "SELECT film_genre.genre_id from film_genre where film_id = %s;",
        (film_id, ))
    old_genres = cursor.fetchall()
    old_genres_id = []
    for genre in old_genres:
        old_genres_id.append(tuple(genre)[0])
    try:
        for genre in genres_id:
            if genre not in old_genres_id:
                cursor.execute(
                    "INSERT INTO film_genre (genre_id, film_id) VALUES (%s,%s);",
                    (genre, film_id))
            else:
                old_genres_id.pop(old_genres_id.index(genre))
        for genre in old_genres_id:
            cursor.execute(
                "DELETE FROM film_genre WHERE genre_id = %s and film_id = %s;",
                (
                    genre,
                    film_id,
                ))
    except connector.errors.DatabaseError as err:
        genres = [item.name for item in genres]
        flash("Введены некорректные данные. Ошибка сохранения.", "danger")
        film = {
            "name": name,
            "description": description,
            "prod_year": prod_year,
            "country": country,
            "producer": producer,
            "screenwriter": screenwriter,
            "actors": actors,
            "duration": duration,
            "genres": genres,
        }
        return render_template("films/edit.html", film=film)
    mysql.connection.commit()
    cursor.close()
    flash(f"Фильм {name} был успешно обновлён.", "success")
    return redirect(url_for("films"))


@app.route("/films/<int:film_id>/delete", methods=["POST"])
@login_required
@check_rights("delete")
def delete(film_id):
    with mysql.connection.cursor(named_tuple=True) as cursor:
        try:
            cursor.execute(
                "DELETE FROM film_genre WHERE film_genre.film_id = %s;",
                (film_id, ))
            cursor.execute(
                "DELETE FROM exam_review WHERE exam_review.film_id = %s;",
                (film_id, ))
            cursor.execute("DELETE FROM exam_films WHERE id=%s;", (film_id, ))
        except connector.errors.DatabaseError as err:
            flash("Не удалось удалить запись", "danger")
            return redirect(url_for("films"))
        mysql.connection.commit()
        flash("Запись успешно удалена", "success")
    return redirect(url_for("films"))


@app.route("/users/<int:user_id>")
@login_required
def show_users(user_id):
    cursor = mysql.connection.cursor(named_tuple=True)
    cursor.execute("SELECT * FROM exam_users WHERE id = %s;", (user_id, ))
    user = cursor.fetchone()
    cursor.execute("SELECT * FROM exam_roles WHERE id=%s;", (user.role_id, ))
    role = cursor.fetchone()
    query = '''SELECT
    exam_films.name,
    exam_review.rating,
    exam_review.review_text
    FROM
    exam_review
    INNER JOIN exam_films ON exam_films.id = exam_review.film_id
    WHERE
    exam_review.user_id = %s;
        '''
    cursor.execute(query, (user_id, ))
    reviews = cursor.fetchall()
    cursor.close()
    return render_template("users/show.html",
                           user=user,
                           role=role,
                           reviews=reviews)


def load_reviews(film_id):
    cursor = mysql.connection.cursor(named_tuple=True)
    cursor.execute(
        """SELECT
    exam_users.last_name,
    exam_users.first_name,
    exam_users.middle_name,
    exam_review.rating,
    exam_review.review_text
FROM
    exam_review
INNER JOIN exam_users ON exam_users.id = exam_review.user_id
WHERE
    exam_review.film_id = %s
""",
        (film_id, ),
    )
    reviews = cursor.fetchall()
    cursor.close()
    review_text_dict = []
    for review in reviews:
        review_text_dict.append({
            "last_name":
            review.last_name,
            "first_name":
            review.first_name,
            "middle_name":
            review.middle_name,
            "rating":
            review.rating,
            "review_text":
            markdown.markdown(review.review_text),
        })
    review_rating = {
        5: "отлично",
        4: "хорошо",
        3: "удовлетворительно",
        2: "неудовлетворительно",
        1: "плохо",
        0: "ужасно",
    }
    return review_text_dict, review_rating


@app.route("/films/<int:film_id>/review-form")
@login_required
def make_review(film_id):
    return render_template("/films/review-form.html", film_id=film_id)


@app.route("/films/<int:film_id>/send_review", methods=["POST"])
@login_required
def send_review(film_id):
    cursor = mysql.connection.cursor(named_tuple=True)
    review_text = request.form.get("review_text") or None
    review_rating = request.form.get("review_rating")
    user_id = request.form.get("review_user")
    query = """
    INSERT INTO exam_review (film_id, user_id, rating, review_text) VALUES (%s,%s,%s,%s)
    """
    cursor.execute(query, (film_id, user_id, review_rating, review_text))
    mysql.connection.commit()
    cursor.close()
    return redirect(url_for("films"))


if __name__ == "__main__":
    app.run(debug=True)