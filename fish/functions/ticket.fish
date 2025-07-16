#!/usr/bin/env fish

# # Ticket Management System
# A Fish shell-based ticket management system for structured development tickets.
#
# ## Features
#
# - **Simple ticket creation**: Creates structured ticket templates with all required sections
# - **Automatic numbering**: Sequential ticket numbers managed automatically
# - **Status management**: Move tickets between todo, done, and backlog
# - **Table listing**: Clean table output with filtering by status
# - **File-based**: Works with structured markdown files in directories
#
# ## Setup
#
# Initialize the ticket system in your project:
# ```fish
# ticket init docs/tickets
# ```
#
# This creates a `.ticket` file that tracks:
# - The tickets directory path
# - The next ticket number to use
#
# ## Usage
#
# ### Initialize ticket system
# ```fish
# ticket init docs/tickets
# ```
#
# ### Create a new ticket
# ```fish
# ticket add "Fix navigation bug on mobile devices"
# ```
#
# This creates a structured ticket template with all required sections.
#
# ### List tickets
# ```fish
# ticket list           # Show all tickets
# ticket list todo      # Show only todo tickets
# ticket list done      # Show only completed tickets
# ```
#
# ### Move tickets between statuses
# ```fish
# ticket move 003 done     # Move ticket 003 to done
# ticket move 005 backlog  # Move ticket 005 to backlog
# ```
#
# ### Show ticket content
# ```fish
# ticket show 003
# ```
#
# Uses `bat` for syntax highlighting if available, falls back to `cat`.
#
# ### Edit ticket
# ```fish
# ticket edit 003
# ```
#
# Opens the ticket in your `$EDITOR` for editing.
#
# ### Delete ticket
# ```fish
# ticket delete 003
# ```
#
# Deletes a ticket after confirmation prompt.
#
# ## Directory Structure
#
# The system expects a directory structure like:
# ```
# docs/tickets/
# ├── backlog/    # Unprioritized tickets
# ├── todo/       # Future tickets
# ├── dev/        # Active tickets
# └── done/       # Completed tickets
# ```
#
# ## File Format
#
# Tickets follow a structured format with:
# - Sequential numbering (001, 002, 003...)
# - Kebab-case titles
# - ISO dates (YYYY-MM-DD)
# - Structured markdown content
#
# Example filename: `003-fix-navigation-bug-2025-07-16.md`
function ticket
    set -l command $argv[1]
    
    switch $command
        case init
            _ticket_init $argv[2..]
        case add
            _ticket_add $argv[2..]
        case list
            _ticket_list $argv[2..]
        case move
            _ticket_move $argv[2..]
        case show
            _ticket_show $argv[2..]
        case edit
            _ticket_edit $argv[2..]
        case delete
            _ticket_delete $argv[2..]
        case ""
            _ticket_help
        case "*"
            echo "Unknown command: $command"
            _ticket_help
            return 1
    end
end

function _ticket_help
    echo "Usage: ticket [command] [args...]"
    echo ""
    echo "Commands:"
    echo "  init <path>          Initialize ticket system with tickets directory"
    echo "  add [-p|--priority PRIORITY] <desc>  Create a new ticket with description"
    echo "  list [status]        List tickets (status: todo, dev, done, backlog, all)"
    echo "  move <num> <status>  Move ticket to different status"
    echo "  show <num>           Show ticket content"
    echo "  edit <num>           Edit ticket in \$EDITOR"
    echo "  delete <num>         Delete ticket (with confirmation)"
    echo ""
    echo "Examples:"
    echo "  ticket init /path/to/tickets/dir"
    echo "  ticket add 'Fix navigation bug on mobile'"
    echo "  ticket add -p high 'Critical security issue'"
    echo "  ticket list todo"
    echo "  ticket move 003 dev"
    echo "  ticket move 003 done"
    echo "  ticket show 003"
    echo "  ticket edit 003"
    echo "  ticket delete 003"
end

function _ticket_get_config
    if not test -f .ticket
        echo "Error: No .ticket file found. Run 'ticket init <path>' first."
        return 1
    end
    
    set -l tickets_dir (head -1 .ticket)
    set -l next_num (tail -1 .ticket)
    
    if not test -d $tickets_dir
        echo "Error: Tickets directory '$tickets_dir' does not exist."
        return 1
    end
    
    echo $tickets_dir
    echo $next_num
end

function _ticket_find_file
    set -l num $argv[1]
    set -l tickets_dir $argv[2]
    
    for file in $tickets_dir/**/*.md
        if test -f $file
            set -l basename (basename $file)
            set -l file_num (echo $basename | sed 's/^\([0-9]\{3\}\).*/\1/')
            if test $file_num = $num
                echo $file
                return 0
            end
        end
    end
    
    return 1
end

function _ticket_init
    set -l tickets_dir $argv[1]
    
    if test -z "$tickets_dir"
        echo "Error: Please provide a tickets directory path."
        echo "Usage: ticket init <path>"
        return 1
    end
    
    if not test -d $tickets_dir
        echo "Error: Directory '$tickets_dir' does not exist."
        return 1
    end
    
    # Find the highest existing ticket number
    set -l highest 0
    for file in $tickets_dir/**/*.md
        if test -f $file
            set -l basename (basename $file)
            set -l num (echo $basename | sed 's/^\([0-9]\{3\}\).*/\1/')
            if test $num -gt $highest
                set highest $num
            end
        end
    end
    
    set -l next_num (math $highest + 1)
    
    # Create .ticket config file
    echo $tickets_dir > .ticket
    printf "%03d" $next_num >> .ticket
    
    echo "Initialized ticket system:"
    echo "  Tickets directory: $tickets_dir"
    echo "  Next ticket number: "(printf "%03d" $next_num)
end

function _ticket_add
    argparse 'p/priority=' -- $argv
    or return 1
    
    set -l priority $_flag_priority
    if test -z "$priority"
        set priority "TBD"
    end
    
    set -l description (string join " " $argv)
    
    if test -z "$description"
        echo "Error: Please provide a ticket description."
        echo "Usage: ticket add [-p|--priority PRIORITY] <description>"
        return 1
    end
    
    set -l config (_ticket_get_config)
    if test $status -ne 0
        return 1
    end
    
    set -l tickets_dir $config[1]
    set -l next_num $config[2]
    
    # Create filename
    set -l date (date +%Y-%m-%d)
    set -l title_slug (echo $description | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    set -l filename "$next_num-$title_slug-$date.md"
    set -l filepath "$tickets_dir/backlog/$filename"
    
    # Generate ticket template directly to file
    _ticket_template $description $next_num $date $priority > $filepath
    
    # Update next ticket number
    set -l new_next (math $next_num + 1)
    echo $tickets_dir > .ticket
    printf "%03d" $new_next >> .ticket
    
    echo "Created ticket: $filename"
    echo "Location: $filepath"
end

function _ticket_list
    set -l status_filter $argv[1]
    
    set -l config (_ticket_get_config)
    if test $status -ne 0
        return 1
    end
    
    set -l tickets_dir $config[1]
    
    # Set default filter to 'all' if not specified
    if test -z "$status_filter"
        set status_filter "all"
    end
    
    # Collect ticket files based on status filter
    set -l files
    switch $status_filter
        case todo
            set files $tickets_dir/todo/*.md
        case dev
            set files $tickets_dir/dev/*.md
        case done
            set files $tickets_dir/done/*.md
        case backlog
            set files $tickets_dir/backlog/*.md
        case all
            set files $tickets_dir/**/*.md
        case "*"
            echo "Error: Invalid status. Use: todo, dev, done, backlog, or all"
            return 1
    end
    
    
    # Check if any files exist
    if test (count $files) -eq 0
        echo "No tickets found."
        return 0
    end
    
    # Check if the glob pattern matched actual files
    set -l actual_files
    for file in $files
        if test -f $file
            set actual_files $actual_files $file
        end
    end
    
    if test (count $actual_files) -eq 0
        echo "No tickets found."
        return 0
    end
    
    set files $actual_files
    
    # Print header
    printf "%-4s %-35s %-8s %-8s %-10s %s\n" "NUM" "TITLE" "STATUS" "PRIORITY" "EFFORT" "DATE"
    printf "%-4s %-35s %-8s %-8s %-10s %s\n" "---" "---" "---" "---" "---" "---"
    
    # Process each ticket file
    for file in $files
        if test -f $file
            set -l basename (basename $file)
            set -l num (echo $basename | sed 's/^\([0-9]\{3\}\).*/\1/')
            set -l date (echo $basename | sed 's/.*-\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\.md$/\1/')
            
            # Determine status from directory
            set -l file_status
            if string match -q "*/todo/*" $file
                set file_status "todo"
            else if string match -q "*/dev/*" $file
                set file_status "dev"
            else if string match -q "*/done/*" $file
                set file_status "done"
            else if string match -q "*/backlog/*" $file
                set file_status "backlog"
            else
                set file_status "unknown"
            end
            
            # Extract title, priority, and effort from file content
            set -l title (head -1 $file | sed 's/^# Ticket #[0-9]\{3\}: //' | cut -c1-35)
            set -l priority (grep "^\*\*Priority:\*\*" $file | sed 's/.*Priority:\*\* \([^*]*\).*/\1/' | tr -d ' ')
            set -l effort (grep "^\*\*Estimated Effort:\*\*" $file | sed 's/.*Effort:\*\* \([^*]*\).*/\1/' | tr -d ' ')
            
            # Truncate title if too long
            if test (string length $title) -gt 35
                set title (string sub -l 32 $title)"..."
            end
            
            printf "%-4s %-35s %-8s %-8s %-10s %s\n" $num $title $file_status $priority $effort $date
        end
    end
end

function _ticket_move
    set -l num $argv[1]
    set -l new_status $argv[2]
    
    if test -z "$num" -o -z "$new_status"
        echo "Error: Please provide ticket number and new status."
        echo "Usage: ticket move <number> <status>"
        echo "Status options: todo, dev, done, backlog"
        return 1
    end
    
    set -l config (_ticket_get_config)
    if test $status -ne 0
        return 1
    end
    
    set -l tickets_dir $config[1]
    
    #dd Validate new status
    if not contains $new_status todo dev done backlog
        echo "Error: Invalid status '$new_status'. Use: todo, dev, done, backlog"
        return 1
    end
    
    # Find the ticket file
    set -l ticket_file (_ticket_find_file $num $tickets_dir)
    
    if test $status -ne 0
        echo "Error: Ticket $num not found."
        return 1
    end
    
    # Check if already in target status
    if string match -q "*/$new_status/*" $ticket_file
        echo "Ticket $num is already in $new_status status."
        return 0
    end
    
    # Create new filename preserving original date
    set -l basename (basename $ticket_file)
    set -l new_path "$tickets_dir/$new_status/$basename"
    
    # Move the file
    mv $ticket_file $new_path
    
    if test $status -eq 0
        echo "Moved ticket $num to $new_status status."
        echo "New location: $new_path"
    else
        echo "Error: Failed to move ticket $num."
        return 1
    end
end

function _ticket_show
    set -l num $argv[1]
    
    if test -z "$num"
        echo "Error: Please provide a ticket number."
        echo "Usage: ticket show <number>"
        return 1
    end
    
    set -l config (_ticket_get_config)
    if test $status -ne 0
        return 1
    end
    
    set -l tickets_dir $config[1]
    
    # Find the ticket file
    set -l ticket_file (_ticket_find_file $num $tickets_dir)
    
    if test $status -ne 0
        echo "Error: Ticket $num not found."
        return 1
    end
    
    # Show ticket content using bat
    if command -v bat > /dev/null
        bat $ticket_file
    else
        cat $ticket_file
    end
end

function _ticket_edit
    set -l num $argv[1]
    
    if test -z "$num"
        echo "Error: Please provide a ticket number."
        echo "Usage: ticket edit <number>"
        return 1
    end
    
    set -l config (_ticket_get_config)
    if test $status -ne 0
        return 1
    end
    
    set -l tickets_dir $config[1]
    
    # Find the ticket file
    set -l ticket_file (_ticket_find_file $num $tickets_dir)
    
    if test $status -ne 0
        echo "Error: Ticket $num not found."
        return 1
    end
    
    # Open in editor
    if test -z "$EDITOR"
        echo "Error: \$EDITOR environment variable not set."
        return 1
    end
    
    $EDITOR $ticket_file
end

function _ticket_delete
    set -l num $argv[1]
    
    if test -z "$num"
        echo "Error: Please provide a ticket number."
        echo "Usage: ticket delete <number>"
        return 1
    end
    
    set -l config (_ticket_get_config)
    if test $status -ne 0
        return 1
    end
    
    set -l tickets_dir $config[1]
    
    # Find the ticket file
    set -l ticket_file (_ticket_find_file $num $tickets_dir)
    
    if test $status -ne 0
        echo "Error: Ticket $num not found."
        return 1
    end
    
    # Show ticket title for confirmation
    set -l title (head -1 $ticket_file | sed 's/^# Ticket #[0-9]\{3\}: //')
    
    # Prompt for confirmation
    echo "Are you sure you want to delete ticket #$num: $title?"
    echo "File: $ticket_file"
    read -P "Type 'yes' to confirm: " confirmation
    
    if test "$confirmation" != "yes"
        echo "Delete cancelled."
        return 0
    end
    
    # Delete the file
    rm $ticket_file
    
    if test $status -eq 0
        echo "Deleted ticket #$num: $title"
    else
        echo "Error: Failed to delete ticket #$num"
        return 1
    end
end

function _ticket_template
    set -l description $argv[1]
    set -l ticket_num $argv[2]
    set -l date_iso $argv[3]
    set -l priority $argv[4]
    
    # Convert ISO date to formatted date
    set -l date_formatted (date -j -f "%Y-%m-%d" "$date_iso" "+%B %d, %Y")
    
    printf "# Ticket #%s: %s\n\n" $ticket_num $description
    printf "**Date:** %s\n" $date_formatted
    printf "**Priority:** %s\n" $priority
    printf "**Estimated Effort:** TBD\n\n"
    
    printf "## Problem Statement\n\n"
    printf "<!-- Describe the issue or need that this ticket addresses -->\n"
    printf "<!-- Explain WHY this work is needed -->\n\n"
    
    printf "## Description\n\n"
    printf "<!-- Provide more detailed explanation of the work -->\n"
    printf "<!-- Include any additional context or background information -->\n\n"
    
    printf "## Acceptance Criteria\n\n"
    printf "<!-- Use checkbox format for specific, testable requirements -->\n"
    printf "<!-- What must be true when this ticket is complete? -->\n\n"
    printf "- [ ] \n"
    printf "- [ ] \n"
    printf "- [ ] \n\n"
    
    printf "## Implementation Details\n\n"
    printf "<!-- Technical approach suggestions -->\n"
    printf "<!-- Specific files to modify -->\n"
    printf "<!-- Code examples when helpful -->\n\n"
    
    printf "## Definition of Done\n\n"
    printf "<!-- Final completion checklist -->\n"
    printf "- [ ] Code passes linting (pnpm lint:fix)\n"
    printf "- [ ] Code passes type checking (pnpm check)\n"
    printf "- [ ] \n"
    printf "- [ ] \n"
end
