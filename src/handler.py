import logging
import os
from datetime import timedelta, timezone

import psycopg2

JST = timezone(timedelta(hours=+9), 'JST')

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def execute_sql(database_url, sql):
  logger.info(sql)
  rows = None
  with psycopg2.connect(database_url) as conn:
    with conn.cursor() as cursor:
      cursor.execute(sql)
      if 'SELECT' in cursor.statusmessage:
        rows = cursor.fetchall()
  return rows


def column_all_sql():
  return """
    SELECT
      c.table_name,
      c.column_name
    FROM
      information_schema.columns AS c
    WHERE
      c.table_schema = 'public'
    ORDER BY
      c.table_name,
      c.column_name;
  """


def main(event, context):
  logger.info(event)

  database_url = os.environ.get('DATABASE_URL')

  if database_url is None:
    raise Exception('Not found DATABASE_URL environment value')

  rows = execute_sql(database_url, column_all_sql())
  logger.info(rows)
  logger.info(rows[0])


if __name__ == "__main__":
  main(None, None)
