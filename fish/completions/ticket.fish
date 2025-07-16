# Completions for ticket command

# Helper function to check if ticket system is initialized
function __ticket_is_initialized
    test -f .ticket
end

# Helper function to get ticket numbers
function __ticket_get_numbers
    if not __ticket_is_initialized
        return 1
    end
    
    set -l tickets_dir (head -1 .ticket)
    if not test -d $tickets_dir
        return 1
    end
    
    for file in $tickets_dir/**/*.md
        if test -f $file
            set -l basename (basename $file)
            set -l num (echo $basename | sed 's/^\([0-9]\{3\}\).*/\1/')
            echo $num
        end
    end
end

# Helper function to get ticket numbers with descriptions
function __ticket_get_numbers_with_desc
    if not __ticket_is_initialized
        return 1
    end
    
    set -l tickets_dir (head -1 .ticket)
    if not test -d $tickets_dir
        return 1
    end
    
    for file in $tickets_dir/**/*.md
        if test -f $file
            set -l basename (basename $file)
            set -l num (echo $basename | sed 's/^\([0-9]\{3\}\).*/\1/')
            set -l title (head -1 $file | sed 's/^# Ticket #[0-9]\{3\}: //')
            echo "$num	$title"
        end
    end
end

# Main command completions
complete -c ticket -f

# Subcommands
complete -c ticket -n '__fish_use_subcommand' -a 'init' -d 'Initialize ticket system'
complete -c ticket -n '__fish_use_subcommand' -a 'add' -d 'Create a new ticket'
complete -c ticket -n '__fish_use_subcommand' -a 'list' -d 'List tickets'
complete -c ticket -n '__fish_use_subcommand' -a 'move' -d 'Move ticket to different status'
complete -c ticket -n '__fish_use_subcommand' -a 'show' -d 'Show ticket content'
complete -c ticket -n '__fish_use_subcommand' -a 'edit' -d 'Edit ticket in $EDITOR'
complete -c ticket -n '__fish_use_subcommand' -a 'delete' -d 'Delete ticket (with confirmation)'

# init subcommand - complete with directories
complete -c ticket -n '__fish_seen_subcommand_from init' -a '(__fish_complete_directories)'

# add subcommand - priority flag
complete -c ticket -n '__fish_seen_subcommand_from add' -s p -l priority -d 'Set ticket priority' -a 'high medium low'

# list subcommand - status options
complete -c ticket -n '__fish_seen_subcommand_from list' -a 'todo dev done backlog all' -d 'Filter by status'

# move subcommand - first argument is ticket number, second is status
complete -c ticket -n '__fish_seen_subcommand_from move; and test (count (commandline -opc)) -eq 2' -a '(__ticket_get_numbers_with_desc)' -d 'Ticket number'
complete -c ticket -n '__fish_seen_subcommand_from move; and test (count (commandline -opc)) -eq 3' -a 'todo dev done backlog' -d 'Target status'

# show subcommand - ticket numbers
complete -c ticket -n '__fish_seen_subcommand_from show' -a '(__ticket_get_numbers_with_desc)' -d 'Ticket number'

# edit subcommand - ticket numbers
complete -c ticket -n '__fish_seen_subcommand_from edit' -a '(__ticket_get_numbers_with_desc)' -d 'Ticket number'

# delete subcommand - ticket numbers
complete -c ticket -n '__fish_seen_subcommand_from delete' -a '(__ticket_get_numbers_with_desc)' -d 'Ticket number'