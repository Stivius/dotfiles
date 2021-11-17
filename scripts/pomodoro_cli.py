#!/usr/bin/env python3

import sqlite3
import argparse
from datetime import datetime

parser = argparse.ArgumentParser(description='Pomodoro actions')
parser.add_argument('--init', help='initialize pomodro database', action='store_true')

parser.add_argument('--projects', help='list of created projects', action='store_true')
parser.add_argument('--add-project', metavar='project_name', help='add new project')

parser.add_argument('--tasks', metavar='project_id', help='list of tasks in progress', type=int)
parser.add_argument('--all-tasks', metavar='project_id', help='list of all tasks', type=int)
parser.add_argument('--rest', action='store_true')
parser.add_argument('--add-task', metavar=('project_id', 'task_name'), nargs=2, help='add new task to project')
parser.add_argument('--remove-task', metavar='task_id', type=int)
parser.add_argument('--finish-task', metavar='task_id', type=int)

parser.add_argument('--start-pomo', metavar='task_id', type=int)
parser.add_argument('--end-pomo', metavar='pomo_id', type=int)
parser.add_argument('--end-current-pomo', action='store_true')
parser.add_argument('--remove-pomo', metavar='pomo_id', type=int)
parser.add_argument('--remove-current-pomo', action='store_true')
parser.add_argument('--all-pomos', action='store_true')
parser.add_argument('--active-pomos', action='store_true')

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
    cursor.execute('''CREATE TABLE IF NOT EXISTS pomos(
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
        add_task(2, "Short Break", cursor)
        add_task(2, "Long Break", cursor)

def list_projects(cursor):
    cursor.execute('''SELECT id, name FROM projects WHERE id<>2''')
    record = cursor.fetchall()
    for item in record:
        id, name = item
        print(id, name, sep='\t')

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
            done = "In-Progress" if not done else "Done"
            print(id, name, done, sep='\t')

def list_rest(cursor):
    cursor.execute('''SELECT id, name FROM tasks WHERE project_id=2''')
    record = cursor.fetchall()
    for item in record:
        id, name = item
        print(id, name, sep='\t')

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

def get_last_active_pomo(cursor):
    cursor.execute('''SELECT max(id) FROM pomos WHERE end_dt IS NULL''')
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
    if task_id > 0:
        cursor.execute('''DELETE FROM tasks WHERE id={0}'''.format(task_id))
        sqlite_connection.commit()
    else:
        print("remove_task: task_id is invalid")

def start_pomo(task_id, cursor):
    if task_id > 0:
        now = datetime.now().isoformat(sep=' ', timespec='seconds')
        cursor.execute('''INSERT INTO pomos (id, start_dt, end_dt, task_id) VALUES (NULL, '{0}', NULL, {1})'''.format(now, task_id))
        sqlite_connection.commit()
        print(get_last_id('pomos', cursor))
    else:
        print("start_pomo: task_id is invalid")

def end_pomo(pomo_id, cursor):
    if pomo_id > 0:
        now = datetime.now().isoformat(sep=' ', timespec='seconds')
        cursor.execute('''UPDATE pomos SET end_dt='{0}' WHERE id={1} AND end_dt IS NULL '''.format(now, pomo_id))
        sqlite_connection.commit()
    else:
        print("end_pomo: pomo_id is invalid")

def end_current_pomo(cursor):
    current_pomo_id = get_last_active_pomo(cursor)
    end_pomo(current_pomo_id, cursor)

def finish_task(task_id, cursor):
    if pomo_id > 0:
        cursor.execute('''UPDATE tasks SET done=1 WHERE id={0} '''.format(task_id))
        sqlite_connection.commit()
    else:
        print("finish_task: task_id is invalid")

def remove_pomo(pomo_id, cursor):
    if pomo_id > 0:
        cursor.execute('''DELETE FROM pomos WHERE id={0}'''.format(pomo_id))
        sqlite_connection.commit()
        print("removed")
    else:
        print("remove_pomo: pomo_id is invalid")

def remove_current_pomo(cursor):
    current_pomo_id = get_last_active_pomo(cursor)
    remove_pomo(current_pomo_id, cursor)

def get_pomos(active_only, cursor):
    if not active_only:
        cursor.execute('''SELECT * FROM pomos''')
    else:
        cursor.execute('''SELECT * FROM pomos WHERE end_dt IS NULL''')
    records = cursor.fetchall()
    for record in records:
        id, start_dt, end_dt, task_id = record
        task_name = get_name_by_id('tasks', task_id, cursor)
        start_dt = datetime.strptime(start_dt, '%Y-%m-%d %H:%M:%S')
        end_dt = datetime.strptime(end_dt, '%Y-%m-%d %H:%M:%S') if end_dt else "Not Finished"
        print(id, end_dt-start_dt, task_name)

try:
    sqlite_connection = sqlite3.connect('/home/stivius/scripts/pomodoro.db')
    cursor = sqlite_connection.cursor()

    if (args.init):
        init(cursor)

    # Projects
    if (args.projects):
        list_projects(cursor)

    if (args.add_project):
        add_project(args.add_project, cursor)

    # Tasks
    if (args.tasks):
        list_tasks(args.tasks, True, cursor)

    if (args.all_tasks):
        list_tasks(args.all_tasks, False, cursor)

    if (args.rest):
        list_rest(cursor)

    if (args.add_task):
        project_id, task_name = args.add_task
        add_task(project_id, task_name, cursor)

    if (args.remove_task):
        remove_task(args.remove_task, cursor)

    if (args.finish_task):
        finish_task(args.finish_task, cursor)

    # Pomos
    if (args.start_pomo):
        start_pomo(args.start_pomo, cursor)

    if (args.end_pomo):
        end_pomo(args.end_pomo, cursor)

    if (args.end_current_pomo):
        end_current_pomo(cursor)

    if (args.remove_pomo):
        remove_pomo(args.remove_pomo, cursor)

    if (args.remove_current_pomo):
        remove_current_pomo(cursor)

    if (args.all_pomos):
        get_pomos(False, cursor)

    if (args.active_pomos):
        get_pomos(True, cursor)


    cursor.close()

except sqlite3.Error as error:
    print("SQLite error:", error)
finally:
    if (sqlite_connection):
        sqlite_connection.close()

