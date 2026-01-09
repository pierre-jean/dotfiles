###### Section: Menu Library ######

def build-ordered-list-menu [name: string, current_state: list<string>, available_choices: list<string>] {
    print -e $"($name): ($current_state)"
    let default_actions = [
        { option: "Do noting", label: "Finish" }
        { option: "Clear List", label: "Clear list" }
    ]
    let choices = $available_choices | each { { option: $in, label: $"Add to list: (ansi attr_bold)($in)(ansi reset)" } }
    let menu  = ($default_actions | append $choices | enumerate | flatten)
    let option = $menu | input list --display label
    if ($option.index == 0) {
        return $current_state
    } else if ($option.index == 1) {
        return (build-ordered-list-menu $name [] $available_choices)
    } else {
        return (build-ordered-list-menu $name ($current_state | append $option.option) $available_choices)
    }
}

def action_on_menu [menu, name = ""] {
    let choice = $menu | get label | input list $name 
    let action = $menu | where { |m| $m.label == $choice } | get --optional action | default { } | first
    do $action
}

def action_on_shortcut [menu, name = "Actions (Press Key)"] {
    let actions = $menu | where { $in | get -o show | $in != false } |each { |m| [$m.shortcut] | wrap ($m.label)}
    mut submenu = $actions | first
    for entry in ($actions | skip 1) {
        $submenu = $submenu | merge $entry
    }
    [$submenu] | wrap $name | print-table  
    let key = (input listen --types [ "key"])
    for entry in $menu {
        if ($key.code == $entry.shortcut) {
            do $entry.action
        }
    }
}

###### End Section: Menu Library ######


###### Section: Todo Menus ######

def create_menu_add_task [ todos, options ] {
    { label: "Add task", shortcut: "a", action: { add_task $todos $options } }
}

def create_submenu_quick_select [todos, options] {
    seq 0 9 | each { |n| { label: $"($n)", shortcut: ($n | into string), action: { update_select_numbers $options $n }, show: false } }
}

def create_submenu_clear_select [ todos, options ] {
    { label: "Esc", shortcut: "esc", action : { clear_select_numbers $options}, show: false }
}

def create_menu_modify_tasks [ todos, options ] {
    { label: "Modify tasks", shortcut: "m", action: { modify_tasks $todos $options } }
}

def create_menu_archive [ todos, options ] {
    { label: "Clean/Archive", shortcut: "c", action: { archive $todos $options } }
}

def create_menu_options [ todos, options ] {
    let menu = [
        (create_submenu_filters $todos $options),
        (create_submenu_sorting $todos $options),
        (create_submenu_visible_columns $todos $options),
        (create_submenu_view_options $todos $options)
     ]
    { label: "Options", shortcut: "o", action: { action_on_shortcut $menu "Actions for Options"  } }
}

def create_menu_explore [ todos, options ] {
    { label: "Explore tasks", shortcut: "e", action: { ($todos | explore); } }    
}

def create_submenu_filters [ todos, options ] {
    let menu = [
        (create_submenu_filters_context $todos $options),
        (create_submenu_filters_project $todos $options)
     ]
    { label: "Filters", shortcut: "f", action: { action_on_shortcut $menu "Filters Options actions" } }
}

def create_submenu_visible_columns [ todos, options ] {
    { label: "Visible Columns", shortcut: "c", action: { edit_visible_columns $todos $options } }
}

def create_submenu_sorting [ todos, options ] {
    { label: "Sorting", shortcut: "s", action: { sort_todos $todos $options  } }
}

def create_submenu_view_options [ todos, options ] {
    { label: "View options", shortcut: "v", action: { $options | print-table ; input "Press key"} }
}

def create_submenu_filters_project [ todos, options ] {
    { label: "Filters by projects", shortcut: "p", action: { filter_by_projects $todos $options } }
}

def create_submenu_filters_context [ todos, options ] {
    { label: "Filters by contexts", shortcut: "c", action: { filter_by_contexts $todos $options } }
}

def create_menu_quick_task [ todos, options ] {
    let menu = [
        (create_submenu_quick_check $todos $options)
        (create_submenu_quick_delete $todos $options)
        (create_submenu_quick_priority_up $todos $options)
        (create_submenu_quick_priority_down $todos $options)
        (create_submenu_quick_deprioritize $todos $options)
     ]
    { label: "Quick action", shortcut: "x", action: { action_on_shortcut $menu "Action on selected task" } }
}

def create_menu_quit [ todos, options ] {
    { label: "Quit", shortcut: "q", action: { reset-selection $options; exit 0 }}
}

def create_submenu_quick_check [ todos, options ] {
    { label: "Mark as Done", shortcut: "x", action: { mark_selected_as_done $todos $options }}    
}

def create_submenu_quick_delete [ todos, options ] {
    { label: "Delete", shortcut: "d", action: { delete_selected_task $todos $options } }
}

def create_submenu_quick_priority_up [ todos, options ] {
    { label: "Priority up", shortcut: "]", action: { priority_up_selected $todos $options }}
}

def create_submenu_quick_priority_down [ todos, options ] {
    { label: "Priority down", shortcut: "[", action: { priority_down_selected $todos $options }}
}

def create_submenu_quick_deprioritize [ todos, options ] {
    { label: "Deprioritize", shortcut: ".", action: { deprioritize_selected $todos $options }}
}

###### End Section: Todo Menus ######


###### Section: Actions ######

def update_select_numbers [ options, number ] {
    let existing_numbers = $options | get --optional task_selected | default []
    let new_options = $options | merge { task_selected: ($existing_numbers | append $number)  }
    $new_options | save-options $in 
}

def clear_select_numbers [ options ] {
    $options | update task_selected [] | save-options $in
}

def edit_visible_columns [ todos, options ] {
    let visible_columns = build-ordered-list-menu "Show columns: " ($options | get-visible-columns-options  ) ($todos | columns)
    $options | merge { visible_columns : ($visible_columns ++ [i] | uniq)} | save-options $in
}

def archive [ todos, options ] {
    let done_tasks = $todos | where {|t| $t.completed }
    $done_tasks | archive-todos $options
    $todos | where {|t| $t.i not-in $done_tasks.i } | save-todos $options
}

def sort_todos [ todos, options ] {
    let sort_by = build-ordered-list-menu "Sort by:" ($options | get --optional sort_by | default []) ($todos | columns | append "⇅ reverse order" )
    $options | merge { sort_by: $sort_by} | save-options $in
}

def select_or_new [choices, choice_label, new_label, question_label] {
    let choices_with_labels = $choices | each {|c| { item: $c, label: $"($choice_label): ($c)"}}
    let all_choices = $choices_with_labels | insert 0 { item: "Default", label: $"($new_label)" } | enumerate | flatten
    mut selection = $all_choices | input list --multi $"($question_label):" --display label
    if ($selection | select index | 0 in $in.index) {
        let new_entry = input $question_label
        $selection = $selection | where { $in.index != 0 } | append { item: $new_entry }
    }
    $selection | get item
}

def add_task [ todos, options ] {
    let task_description = input "Task description: "
    let projects_choices = $todos | get projects | flatten | uniq
    let selected_projects = select_or_new $projects_choices "Add to projects" "Add to new project" "New project name: "
    let contexts_choices = $todos | get contexts | flatten | uniq
    let selected_contexts = select_or_new $contexts_choices "Add to contexts" "Add to new context" "New context name: "
    let i = $todos | get i | default --empty [-1] | math max | $in + 1 
    let new_task = (parse-todo $task_description
    | merge { i: $i }
    | merge { projects: ($in.projects ++ $selected_projects | uniq) }
    | merge { contexts: ($in.contexts ++ $selected_contexts | uniq) }
    | merge { creation_date: (date now | format date "%Y-%m-%d" )}
    )
    $todos | append $new_task | sort-by i | save-todos $options
}

def filter_by_projects [ todos, options ] {
        let projects = $todos | get projects | flatten | uniq
        if ($projects | is-not-empty ) {
            let selected_projects = $projects | input list --multi "Show only these projects:"
            let updated_options = $options | merge deep { filters: { projects: $selected_projects }}
            save-options $updated_options
        } else {
            print -e "No projects to filter on"; sleep 1sec;
            save-options ($options | merge { filters: { projects: [] }})
        }
}

def filter_by_contexts [ todos, options ] {
        let contexts = $todos | get contexts | flatten | uniq
        if ($contexts | is-not-empty) {
            let selected_contexts = $contexts | input list --multi "Show only these contexts:"
            let updated_options = $options | merge deep { filters: { contexts: $selected_contexts }}
            save-options $updated_options
        } else {
            print -e "No contexts to filter on"; sleep 1sec;
            save-options ($options | merge { filters: { contexts: [] }})
        }
}

def modify_tasks [todos, options] {
        let visible_todos = $todos | get_visible_todos $options
        let selected_tasks = $visible_todos | input list --multi --display summary
        let action = [ "Mark as done", "Change priority", "Delete", "Add projects", "Add contexts", "Remove projects", "Remove contexts"] | input list "Modify selected tasks:"
        if ($action == 'Mark as done') {
            $selected_tasks | update completed true | merge_into_state $todos | save-todos $options
        } else if ($action == "Change priority") {
            let choices = seq char A Z | insert 0 "Deprioritize"
            let priority = $choices | input list "Priority"
            $selected_tasks | each { |t| update priority ( if ($priority == "Deprioritize") { null } else { $priority } )}  | merge_into_state $todos | save-todos $options
        } else if ($action == 'Add projects') {
            let projects_choices = $todos | get projects | flatten | uniq
            let selected_projects = select_or_new $projects_choices "Add to projects" "Add to new project" "New project name: "
            $selected_tasks | each { |t| update projects (($t.projects | default []) ++ $selected_projects | uniq)} | merge_into_state $todos | save-todos $options
        } else if ($action == 'Remove projects') {
            let tasks_projects =  $selected_tasks | get projects | flatten | uniq
            if ($tasks_projects | is-not-empty) {
                let selected_projects = $tasks_projects | input list --multi "Select projects to remove from tasks: " 
                ($selected_tasks
                | each { |t| update projects ($t.projects | where {|p| $p not-in $selected_projects}) }
                | merge_into_state $todos
                | save-todos $options)
            } 
        } else if ($action == 'Add contexts') {
            let contexts_choices = $todos | get contexts | flatten | uniq
            let selected_contexts = select_or_new $contexts_choices "Add to contexts" "Add to new context" "New context name: "
            $selected_tasks | each { |t| update contexts ($t.contexts ++ $selected_contexts | uniq)} | merge_into_state $todos | save-todos $options
        } else if ($action == 'Remove contexts') {
            let tasks_contexts =  $selected_tasks | get contexts | flatten | uniq
            if ($tasks_contexts | is-not-empty) {
                let selected_contexts = $tasks_contexts | input list --multi "Select contexts to remove from tasks: " 
                $selected_tasks | each { |t| update contexts ($t.contexts | where {|p| $p not-in $selected_contexts}) } | merge_into_state $todos | save-todos $options
            } 
        } else if ($action == 'Delete') {
            $todos | where {|t| $t.i not-in $selected_tasks.i } | save-todos $options
        }
}

def merge_into_state [ todo_state ] {
    let new_tasks = $in
    $todo_state | where { |t| $t.i not-in ($new_tasks | get i)} | append $new_tasks | sort-by i
}

def get_visible_todos [ options ] {
    let todos = $in
    mut visible_todos = $todos
    let projects_filter =  $options | get --optional filters | get --optional projects
    if ( $projects_filter | is-not-empty) {
        $visible_todos = $visible_todos | where { |t| ($t.projects | any { |p| $p in $projects_filter})}
    }
    let contexts_filter =  $options | get --optional filters | get --optional contexts
    if ( $contexts_filter | is-not-empty) {
        $visible_todos = $visible_todos | where { |t| ($t.contexts | any { |p| $p in $contexts_filter})}
    }
    for sortby in ($options | get --optional sorted-by | default [] ) {
        $visible_todos = $visible_todos | sort-by ( [$sortby ] | into cell-path )
    }
    $visible_todos
}

def select_columns [ todos, options ] {
    let column_names = $options | get-visible-columns-options 
    let column_paths = $column_names | each {|c| [$c] | into cell-path }
    $todos | select ...$column_paths
}

def underline_selection [ todos, options ] {
    let selected = get_selected_task $todos $options
    $todos | each { |t| if ($t.i in $selected.i) {
        update summary $"(ansi green_bold)▶ (ansi reset)($t.summary)(ansi green_bold) ◀(ansi reset)"
    } else { $t } }
}

def get_selected_task [ todos, options ] {
    let selected_index = $options | get -o task_selected | default --empty [-1] | str join "" | default --empty "-1" | into int
    $todos | where { |t| $t.i == $selected_index }
}

def mark_selected_as_done  [ todos, options ] {
    get_selected_task $todos $options | each { update completed true } | merge_into_state $todos | save-todos $options
    reset-selection $options
}

def delete_selected_task [ todos, options ] {
    let selected = get_selected_task $todos $options
    if (["yes", "no"] | input list --fuzzy "Are you sure you want to delete that task?" | $in == "yes") {
        $todos | where {|t| $t.i not-in $selected.i} | save-todos $options
    }
    reset-selection $options
}

def priority_up_selected [ todos, options ] {
    let selected = get_selected_task $todos $options
    let new_priority = seq char A Z | reverse | skip until {|c| $c in $selected.priority } | skip 1 | default --empty ['A'] | first
    $selected | update priority $new_priority | merge_into_state $todos | save-todos $options
    reset-selection $options
}

def priority_down_selected [ todos, options ] {
    let selected = get_selected_task $todos $options
    let new_priority = seq char A Z | skip until {|c| $c in $selected.priority} | skip 1 | default --empty ['Z'] | first
    if ( $new_priority | is-not-empty ) { $selected | update priority $new_priority | merge_into_state $todos | save-todos $options }
    reset-selection $options
}

def deprioritize_selected [ todos, options ] {
    let selected = get_selected_task $todos $options
    $selected | update priority null | merge_into_state $todos | save-todos $options
    reset-selection $options
}

def reset-selection [ options ] {
    clear_select_numbers $options 
}

def filter-by-contexts [todos, options] {
    let filters = $options | get-filters-contexts-option
    if ($filters | is-not-empty) {
        $todos | where { |t| ($t.contexts | any { |p| $p in $filters })}
    } else {
        $todos
    }
}

def filter-by-projects [todos, options] {
    let filters = $options | get-filters-projects-option
    if ($filters | is-not-empty) {
        $todos | where { |t| ($t.projects | any { |p| $p in $filters })}
    } else {
        $todos
    }
}

def sort-todos [todos, options] {
    mut to_sort = $todos
     for sortby in ($options | get-sort-by-options) {
        if ($sortby == "⇅ reverse order") {
            $to_sort = $to_sort | reverse
        } else {
            $to_sort = $to_sort | sort-by ( [$sortby] | into cell-path)
        }
    }
    $to_sort
}

def todotui [--folder: path] {
    while ( true ) {
        clear
        let options = load-options --folder $folder
        let todos = load-todos $options
        mut visible_todos = $todos
        $visible_todos = filter-by-contexts $visible_todos $options
        $visible_todos = filter-by-projects $visible_todos $options
        $visible_todos = sort-todos $visible_todos $options
        $visible_todos = select_columns $visible_todos $options
        $visible_todos = underline_selection $visible_todos $options
        $visible_todos | print-table
        if ($options | get-sort-by-options | is-not-empty) {
            print -e $"(ansi yellow_dimmed) ⇅ Sorting by: [($options | get-sort-by-options | str join ', ')](ansi reset)"
        }
        if ($options | get-filters-contexts-option | is-not-empty) {
            print -e $"(ansi cyan_dimmed) ⛉ Filtering on contexts: [($options | get-filters-contexts-option | str join ', ')](ansi reset)"
        }
        if ($options | get-filters-projects-option | is-not-empty) {
            print -e $"(ansi cyan_dimmed) ⛉ Filtering on projects: [($options | get-filters-projects-option | str join ', ')](ansi reset)"
        }

        let menu = ([
            (create_menu_add_task $todos $options),
            (create_menu_modify_tasks $todos $options),
            (create_menu_archive $todos $options),
            (create_menu_explore $todos $options),
            (create_menu_options $todos $options),
            (create_menu_quit $todos $options)
        ]
        ++ (create_submenu_quick_select $todos $options)
        | append (create_submenu_clear_select $todos $options)
        )

        let menu_with_quick_action = if ( get_selected_task $visible_todos $options | is-not-empty) {
            $menu | insert 0 (create_menu_quick_task $todos $options)
        } else {
            $menu
        }

        action_on_shortcut $menu_with_quick_action "Actions"
    }
}

def "todo" [--folder: path, --columns: list<string>, --projects: list<string>, --contexts: list<string>] {
    todo interact
}

def "todo interact" [--folder: path] {
    todotui --folder=$folder
}

def "todo list" [--folder: path] {
    load-todos (load-options --folder=$folder)
}

def "todo archive" [--folder: path] {
    let options = load-options --folder=$folder
    let todos = load-todos $options
    archive $todos $options
}

def "todo done" [--folder: path] {
    let options = load-options --folder=$folder
    load-done $options
}

def "todo done today" [--folder: path] {
    let options = load-options --folder=$folder
    load-done $options | where { $in.completion_date == (date now | format date "%Y-%m-%d") }
}

def "todo done yesterday" [--folder: path] {
    let options = load-options --folder=$folder
    load-done $options | where { $in.completion_date == (date now | $in - 1day | format date "%Y-%m-%d") }
}

def "todo done last-week" [--folder: path] {
    let options = load-options --folder=$folder
    load-done $options | where { $in.completion_date >= (date now | $in - 7day | format date "%Y-%m-%d") }
}

def "print-table" [] {
    $in | table --expand --index=false | print -e
}


###### Section: parsing / formatting ######

# Parse a single todo.txt line into structured data
def parse-todo [line: string] {
    let parsed = $line | parse --regex '^\s*(?:(?P<completed>x)\s+)?(?:\((?P<priority>[A-Z])\)\s+)?(?:(?P<date1>\d{4}-\d{2}-\d{2})\s+)?(?:(?P<date2>\d{4}-\d{2}-\d{2})\s+)?(?P<description>.*)$'

    if ($parsed | is-empty) {
        return null
    }

    let item = $parsed | first

    let is_completed = ($item.completed == "x")

    # Date logic depends on completion status:
    # - Incomplete: date1 = creation_date
    # - Complete: date1 = completion_date, date2 = creation_date
    let completion_date = if $is_completed { $item.date1 } else { null }
    let creation_date = if $is_completed { $item.date2 } else { $item.date1 }

    # Extract contexts (@word), projects (+word), and key:value pairs
    let contexts = $item.description | parse --regex '@(?P<ctx>\S+)' | get ctx
    let projects = $item.description | parse --regex '\+(?P<proj>\S+)' | get proj
    let metadata = $item.description | parse --regex '(?P<key>[^\s:]+):(?P<value>[^\s:]+)' | each {|m| {key: $m.key, value: $m.value}}
    mut summary = $item.description | str trim
    for context in $contexts {
        $summary = $summary | str replace --all --regex $' ?@($context)' ""
    }
    for project in $projects {
        $summary = $summary | str replace --all --regex $' ?\+($project)' ""
    }
    if ($is_completed) { $summary = $"(ansi s)($summary)(ansi reset)" }
    if ($item.priority | is-not-empty) { $summary = $"(ansi attr_bold)(ansi attr_reverse) ($item.priority) (ansi reset_reverse) ($summary)(ansi reset_bold)"}
    {
        summary: $summary,
        completed: $is_completed,
        priority: (if ($item.priority | is-empty) { null } else { $item.priority }),
        completion_date: (if ($completion_date | is-empty) { null } else { $completion_date }),
        creation_date: (if ($creation_date | is-empty) { null } else { $creation_date }),
        description: $item.description,
        contexts: $contexts,
        projects: $projects,
        metadata: $metadata
    }
}

# Parse entire todo.txt file
def load-todos [options] {
    let todo_file = $options | get-todo-path-option 
    open $todo_file
    | lines
    | enumerate
    | each { |item|
        let parsed = parse-todo $item.item
        if $parsed != null {
            {i: ($item.index + 1), ...$parsed}
        } else {
            null
        }
    }
    | where {|x| $x != null}
}

def load-done [options] {
    let done_file = $options | get-done-path-option
    open $done_file
    | lines
    | enumerate
    | each { |item|
        let parsed = parse-todo $item.item
        if $parsed != null {
            {i: ($item.index + 1), ...$parsed}
        } else {
            null
        }
    }
    | where {|x| $x != null}
}

export def format-todo [item: record] {
    mut parts = []

    # Completion marker
    if $item.completed {
        $parts = ($parts | append "x")
    }

    # Priority (only for incomplete tasks)
    if (not $item.completed) and ($item.priority != null) {
        $parts = ($parts | append $"\(($item.priority)\)")
    }

    # Dates
    if $item.completed {
        # Completed: completion_date then creation_date
        if $item.completion_date != null {
            $parts = ($parts | append $item.completion_date)
        }
        if $item.creation_date != null {
            $parts = ($parts | append $item.creation_date)
        }
    } else {
        # Incomplete: only creation_date
        if $item.creation_date != null {
            $parts = ($parts | append $item.creation_date)
        }
    }

    # Remove deleted projects from description
    mut description = $item.description
    let initial_projects = $item.description | parse --regex '\+(?P<proj>\S+)' | get proj
    for deleted_projects in ($initial_projects | where { $in not-in $item.projects}) {
        $description = $description | str replace --all --regex $' ?\+($deleted_projects)' ""
    }
    # Remove deleted contexts from description
    let initial_contexts = $item.description | parse --regex '@(?P<ctx>\S+)' | get ctx
    for deleted_contexts in ($initial_contexts | where { $in not-in $item.contexts}) {
        $description = $description | str replace --all --regex $' ?\+($deleted_contexts)' ""
    }
    # Add description
    $parts = ($parts | append $description)

    # Append added projects
    if ($item.projects | is-not-empty) {
        let new_projects = $item.projects | where { |p| $item.description | str contains $"+($p)" | $in == false }
        let formatted = $new_projects | each { $"+($in)" } | str join " "
        $parts = ($parts | append $formatted)
    }
    # Append added contexts
    if ($item.contexts | is-not-empty) {
        let new_contexts = $item.contexts | where { |c| $item.description | str contains $"@($c)" | $in == false }
        let formatted = $new_contexts | each { $"@($in)" } | str join " "
        $parts = ($parts | append $formatted)
    }

    $parts | str join " "
}

def save-todos [ options ] : list<record> -> nothing {
    let data = $in | each {|todo| format-todo $todo}
    | where { $in | str trim | is-not-empty }
    | str join "\n"

    # saving backup just in case
    let old_data = open --raw ($options | get-todo-path-option)
    $old_data | save -f $"($options | get-todo-path-option).bk"
    $data | save -f ($options | get-todo-path-option)
}

def archive-todos [ options ] : list<record> -> nothing {
    let data = $in | each {|todo| format-todo $todo}
    | where { $in | str trim | is-not-empty }
    | str join "\n"
    | save --append ($options | get-archive-path-option)
}

###### End Section: parsing / formatting ######


###### Section: Options ######

def get-todo-folder [--folder: path] {
    let default_folder = if ( "~/.todo-txt" | path exists) { "~/.todo-txt" } else { "~/.local/share/todotxt" }
    let todo_folder = $folder | default --empty ($env | get --optional TODO_FOLDER) | default --empty $default_folder | path expand
    mkdir $todo_folder
    $todo_folder
}

def get-todo-path-option [] {
    let folder = $in | get folder
    let todo_file = $"($folder)/todo.txt" | path expand
    touch $todo_file
    $todo_file
}

def get-archive-path-option [] {
    let folder = $in | get folder
    let archive_file = $"($folder)/done.txt" | path expand
    touch $archive_file
    $archive_file
}

def get-done-path-option [] {
    let done_file = $in | get folder | $"($in)/done.txt"
    touch $done_file
    $done_file
}

def get-options-path-option [] {
    let options_file = $in | get folder | $"($in)/options.txt"
    touch $options_file
    $options_file
}

def load-options [--folder: path] {
    let folder = get-todo-folder --folder=$folder | path expand
    mkdir $folder
    let options_path = $"($folder)/options.toml"
    touch $options_path
    open --raw $options_path | from toml | default --empty { folder: $folder }
}

def get-filters-contexts-option [] {
    $in | get --optional filters | get --optional contexts | default --empty []
}

def get-filters-projects-option [] {
    $in | get --optional filters | get --optional projects | default --empty []
}


def get-visible-columns-options [] {
    let columns = $in | get --optional visible_columns | default --empty ["i", "summary", "projects", "contexts", "creation_date"]
    # We always need to make sure "i" is returned as its needed for modification funcationality
    $columns | append "i" | uniq
}

def get-sort-by-options [] {
    $in | get --optional sort_by | default --empty ["creation_date", "i", "priority", "completed"]      
}

def save-options [options] {
    $options | to toml | save -f ($"($options.folder)/options.toml" | path expand)
}

###### End Section: Options ######
