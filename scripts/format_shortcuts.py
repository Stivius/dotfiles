import fileinput

prefix = ''
delim = 0

for line in fileinput.input():
    if line.startswith('---'): # skipping header
        delim += 1
    elif line.startswith('**'): # group shortcuts
        prefix = '[' + line[2:-3] + ']'
    elif line != '\n' and delim > 1:
        line = line.replace("\\`", "\\tick") 
        line = line.replace("`", "") 
        line = line.replace("\\tick", "\\`") 
        if not prefix:
            print(line, end='')
        else:
            print(prefix + ' ' + line, end='')