#!/usr/bin/env python3

import sqlite3
import argparse
import datetime

parser = argparse.ArgumentParser(description='Pomodoro actions')
parser.add_argument('--init', help='initialize pomodro database', action='store_true')
parser.add_argument('--projects', help='list of created projects', action='store_true')
parser.add_argument('--add-project', metavar='project_name', help='add new project')
parser.add_argument('--tasks', metavar='project_id', help='list of tasks in progress')
parser.add_argument('--all-tasks', metavar='project_id', help='list of all tasks')
parser.add_argument('--add-task', metavar=('project_id', 'task_name'), nargs=2, help='add new task to project')
parser.add_argument('--remove-task', metavar='task_id', help='remove task')
parser.add_argument('--finish-task', metavar='task_id', help='add new task to project')
parser.add_argument('--start-pomo', metavar='task_id', help='start pomodoro activity')
parser.add_argument('--end-pomo', metavar='record_id', help='end pomodoro activity')
parser.add_argument('--all-records', help='get all pomodoro records', action='store_true')
parser.add_argument('--remove-record', metavar='task_id', help='remove record')
parser.add_argument('--active-records', help='get pomodoro records in progress', action='store_true')

args = parser.parse_args()

def init(cursor):
    cursor.execute('''CREATE TABLE IF NOT EXISTS projects(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL UNIQUE)''')
    cursor.execute('''CREATE TABLE IF NOT EXISTS tasks(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            done INTEGER NOT NULL,
            project_id INTEGER NOT NULL,
            FOREIGN KEY (project_id) REFERENCES projects(id))''')
    cursor.execute('''CREATE TABLE IF NOT EXISTS records(
            id INTEGER PRIMARY KEY,
            start_dt DATETIME,
            end_dt DATETIME,
            task_id INTEGER NOT NULL,
            FOREIGN KEY (task_id) REFERENCES tasks(id))''')
    cursor.execute('''SELECT * FROM projects WHERE name="Rest"''')
    record = cursor.fetchall()
    if (len(record) == 0):
        add_project("No Project", cursor)
        add_project("Rest", cursor)

def list_projects(cursor):
    cursor.execute('''SELECT id, name FROM projects''')
    record = cursor.fetchall()
    for item in record:
        id, name = item
        print(id, name)

def add_project(name, cursor):
    cursor.execute('''INSERT INTO projects (id, name) VALUES (NULL, '%s')''' % name)
    sqlite_connection.commit()
    print(get_last_id('projects', cursor))

def list_tasks(project_id, in_progress, cursor):
    if (project_id):
        if not in_progress:
            cursor.execute('''SELECT id, name, done FROM tasks WHERE project_id='%s' ''' % project_id)
        else:
            cursor.execute('''SELECT id, name, done FROM tasks WHERE project_id='%s' AND done=0 ''' % project_id)
        record = cursor.fetchall()
        for item in record:
            id, name, done = item
            print(id, name, done)

def get_name_by_id(table, id, cursor):
    cursor.execute('''SELECT name FROM {0} WHERE id='{1}' '''.format(table, id))
    record = cursor.fetchall()
    if (len(record) != 0):
        return record[0][0]
    return -1

def get_last_id(table, cursor):
    cursor.execute('''SELECT max(id) FROM {0} '''.format(table))
    record = cursor.fetchall()
    if (len(record) != 0):
        return record[0][0]
    return -1

def add_task(project_id, task_name, cursor):
    project_id = project_id if project_id != None else "NULL"
    cursor.execute('''INSERT INTO tasks (id, name, done, project_id) VALUES (NULL, '{0}', 0, {1})'''.format(task_name, project_id))
    sqlite_connection.commit()
    print(get_last_id('tasks', cursor))

def remove_task(task_id, cursor):
    cursor.execute('''DELETE FROM tasks WHERE id={0}'''.format(task_id))
    sqlite_connection.commit()

def start_pomo(task_id, cursor):
    now = datetime.datetime.now()
    cursor.execute('''INSERT INTO records (id, start_dt, end_dt, task_id) VALUES (NULL, '{0}', NULL, {1})'''.format(now, task_id))
    sqlite_connection.commit()
    print(get_last_id('records', cursor))

def end_pomo(record_id, cursor):
    now = datetime.datetime.now()
    cursor.execute('''UPDATE records SET end_dt='{0}' WHERE id={1} AND end_dt IS NULL '''.format(now, record_id))
    sqlite_connection.commit()

def finish_task(task_id, cursor):
    now = datetime.datetime.now()
    cursor.execute('''UPDATE tasks SET done=1 WHERE id={0} '''.format(task_id))
    sqlite_connection.commit()

def remove_record(record_id, cursor):
    cursor.execute('''DELETE FROM records WHERE id={0}'''.format(record_id))
    sqlite_connection.commit()

def get_records(active_only, cursor):
    if not active_only:
        cursor.execute('''SELECT * FROM records''')
    else:
        cursor.execute('''SELECT * FROM records WHERE end_dt is NULL''')
    records = cursor.fetchall()
    for record in records:
        id, start_dt, end_dt, project_id, task_id = record
        project_name = get_name_by_id('projects', project_id, cursor)
        task_name = get_name_by_id('tasks', task_id, cursor)
        end_dt = end_dt if end_dt else "NotFinished"
        print(id, start_dt, end_dt, project_name, task_name)

try:
    sqlite_connection = sqlite3.connect('pomodoro.db')
    cursor = sqlite_connection.cursor()

    if (args.init):
        init(cursor)

    if (args.projects):
        list_projects(cursor)

    if (args.add_project):
        add_project(args.add_project, cursor)

    if (args.tasks):
        list_tasks(args.tasks, True, cursor)

    if (args.all_tasks):
        list_tasks(args.all_tasks, False, cursor)

    if (args.add_task):
        project_id, task_name = args.add_task
        add_task(project_id, task_name, cursor)

    if (args.remove_task):
        remove_task(args.remove_task, cursor)

    if (args.finish_task):
        finish_task(args.finish_task, cursor)

    if (args.start_pomo):
        start_pomo(args.start_pomo, cursor)

    if (args.end_pomo):
        end_pomo(args.end_pomo, cursor)

    if (args.all_records):
        get_records(False, cursor)

    if (args.remove_record):
        remove_record(args.remove_record, cursor)

    if (args.active_records):
        get_records(True, cursor)

    cursor.close()

except sqlite3.Error as error:
    print("SQLite error:", error)
finally:
    if (sqlite_connection):
        sqlite_connection.close()

