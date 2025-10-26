def parse-description [line] {
  let description = $line | split row "+" | first
  let tags = $line | split row -r '[ ,;\.]' | where ($it | str starts-with "+") | str substring 1..
  let to = $line | split row -r '[ ,;\.]' | where ($it | str starts-with "@") | str substring 1..
  {
    description: $description,
    tags: $tags,
    to: $to 
  }
}

def parse-todo-task [line] {
  let created = $line | get created | into datetime
  let parsed_description = parse-description ($line | get description)
  {
    created: $created,
    description: ($parsed_description | get description),
    tags: ($parsed_description | get tags),
    locations: (parsed_description | get locations)
  }
}

def format-task [task] {
  let created = $task | format date "+%Y-%m-%d"
  let tags = $task | get tags | str   
}

def parse-todo-file [file: string] {
  open $file | parse "{created} {description}" | each { |line| parse-todo-task $line }
}

def load-todo-file [] {
  let location = $env.TASK_TODO_FILE? | default $"($env.HOME)/.local/share/tasks/todo.txt"
  parse-todo-file $location 
}

def save-todo-file [] {
  
}

def task-add [--tags (-t): list<string> = [], --to: list<string> = [], --created (-c): datetime, description: string] {
  let db = load-todo-file
  let parsed_description = parse-description $description
  let task = {
    created: ($created | default (date now)),
    tags: ($tags | default [] ),
    to: ($to | default [] ),
    description: ($parsed_description | get description)
  }
  db | append $task | 
}
