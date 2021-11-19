#!/usr/bin/env python3

import sqlite3
import argparse
from datetime import datetime
from datetime import timedelta

parser = argparse.ArgumentParser(description='Pomodoro actions')
parser.add_argument('--init', help='initialize pomodro database', action='store_true')

parser.add_argument('--projects', help='list of created projects', action='store_true')
parser.add_argument('--all-projects', help='list of created projects', action='store_true')
parser.add_argument('--add-project', metavar='project_name', help='add new project')
parser.add_argument('--archive-project', metavar='project_id', type=int)
parser.add_argument('--rename-project', metavar=('project_id', 'project_name'), nargs=2)
parser.add_argument('--remove-project', metavar='project_id', type=int)

parser.add_argument('--tasks', metavar='project_id', help='list of tasks in progress', type=int)
parser.add_argument('--all-tasks', metavar='project_id', help='list of all tasks', type=int)
parser.add_argument('--rest', action='store_true')
parser.add_argument('--add-task', metavar=('project_id', 'task_name'), nargs=2, help='add new task to project')
parser.add_argument('--rename-task', metavar=('task_id', 'task_name'), nargs=2)
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
            name TEXT NOT NULL UNIQUE,
            archived INTEGER NOT NULL)''')
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

# Common

def remove(table, id, cursor):
    if id > 0:
        cursor.execute('''DELETE FROM {0} WHERE id={1}'''.format(table, id))
        sqlite_connection.commit()
    else:
        print("remove: id is invalid")

def rename(table, id, name, cursor):
    if id > 0:
        cursor.execute('''UPDATE {0} SET name='{2}' WHERE id={1} '''.format(table, id, name))
        sqlite_connection.commit()
    else:
        print("rename: id is invalid")

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

# Projects

def list_projects(active_only, cursor):
    if not active_only:
        cursor.execute('''SELECT id, name, archived FROM projects WHERE id<>2''')
    else:
        cursor.execute('''SELECT id, name, archived FROM projects WHERE id<>2 and archived=0''')
    record = cursor.fetchall()
    for item in record:
        id, name, archived = item
        archived = "Active" if not archived else "Archived"
        if not active_only:
            print(id, name, archived, sep='\t')
        else:
            print(id, name, sep='\t')

def add_project(name, cursor):
    cursor.execute('''INSERT INTO projects (id, name, archived) VALUES (NULL, '{0}', 0)'''.format(name))
    sqlite_connection.commit()
    print(get_last_id('projects', cursor))

def archive_project(id, cursor):
    cursor.execute('''UPDATE projects SET archived=1 WHERE id={0} '''.format(id))
    sqlite_connection.commit()

def remove_project(id, cursor):
    remove('projects', id, cursor)

def rename_project(id, name, cursor):
    rename('projects', id, name, cursor)

# Tasks

def list_tasks(project_id, in_progress, cursor):
    if (project_id):
        if not in_progress:
            cursor.execute('''SELECT id, name, done FROM tasks WHERE project_id={0} '''.format(project_id))
        else:
            cursor.execute('''SELECT id, name, done FROM tasks WHERE project_id={0} AND done=0 '''.format(project_id))
        record = cursor.fetchall()
        for item in record:
            id, name, done = item
            done = "In-Progress" if not done else "Done"
            total_time, total_amount = get_total_pomos(id, cursor)
            if not in_progress:
                print(id, name, done, total_time, str(total_amount) + " pomos", sep='\t')
            else:
                print(id, name, total_time, str(total_amount) + " pomos", sep='\t')

def list_rest_tasks(cursor):
    cursor.execute('''SELECT id, name FROM tasks WHERE project_id=2''')
    record = cursor.fetchall()
    for item in record:
        id, name = item
        print(id, name, sep='\t')

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

def remove_task(id, cursor):
    remove('tasks', id, cursor)

def rename_task(id, name, cursor):
    rename('tasks', id, name, cursor)

def finish_task(id, cursor):
    if id > 0:
        cursor.execute('''UPDATE tasks SET done=1 WHERE id={0} '''.format(id))
        sqlite_connection.commit()
    else:
        print("finish_task: id is invalid")

# Pomos

def get_total_pomos(task_id, cursor):
    cursor.execute('''SELECT start_dt, end_dt FROM pomos WHERE end_dt IS NOT NULL and task_id={0}'''.format(task_id))
    records = cursor.fetchall()
    total_time = timedelta()
    for record in records:
        start_dt, end_dt = record
        start_dt = datetime.strptime(start_dt, '%Y-%m-%d %H:%M:%S')
        end_dt = datetime.strptime(end_dt, '%Y-%m-%d %H:%M:%S')
        total_time += end_dt-start_dt
    return total_time, len(records)

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

def remove_pomo(pomo_id, cursor):
    remove('pomos', pomo_id, cursor)

def remove_current_pomo(cursor):
    current_pomo_id = get_last_active_pomo(cursor)
    remove_pomo(current_pomo_id, cursor)

def list_pomos(active_only, cursor):
    if not active_only:
        cursor.execute('''SELECT * FROM pomos''')
    else:
        cursor.execute('''SELECT * FROM pomos WHERE end_dt IS NULL''')
    records = cursor.fetchall()
    for record in records:
        id, start_dt, end_dt, task_id = record
        task_name = get_name_by_id('tasks', task_id, cursor)
        if end_dt:
            start_dt = datetime.strptime(start_dt, '%Y-%m-%d %H:%M:%S')
            end_dt = datetime.strptime(end_dt, '%Y-%m-%d %H:%M:%S')
            duration = end_dt-start_dt
        else:
            duration = "In-Progress"
        if not active_only:
            print(id, duration, task_name)
        else:
            print(id, task_name)

try:
    sqlite_connection = sqlite3.connect('/home/stivius/scripts/pomodoro.db')
    cursor = sqlite_connection.cursor()

    if (args.init):
        init(cursor)

    # Projects
    if (args.projects):
        list_projects(True, cursor)

    if (args.all_projects):
        list_projects(False, cursor)

    if (args.add_project):
        add_project(args.add_project, cursor)

    if (args.rename_project):
        project_id, project_name = args.rename_project
        rename_project(int(project_id), project_name, cursor)

    if (args.archive_project):
        archive_project(args.archive_project, cursor)

    if (args.remove_project):
        remove_project(args.remove_project, cursor)

    # Tasks
    if (args.tasks):
        list_tasks(args.tasks, True, cursor)

    if (args.all_tasks):
        list_tasks(args.all_tasks, False, cursor)

    if (args.rest):
        list_rest_tasks(cursor)

    if (args.add_task):
        project_id, task_name = args.add_task
        add_task(project_id, task_name, cursor)

    if (args.remove_task):
        remove_task(args.remove_task, cursor)

    if (args.rename_task):
        task_id, task_name = args.rename_task
        rename_task(int(task_id), task_name, cursor)

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
        list_pomos(False, cursor)

    if (args.active_pomos):
        list_pomos(True, cursor)


    cursor.close()

except sqlite3.Error as error:
    print("SQLite error:", error)
finally:
    if (sqlite_connection):
        sqlite_connection.close()

