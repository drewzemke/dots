#!/usr/bin/env fish
#
# if passed a .ts, .tsx, .js, or .jsx filenmae, 
#  prints a .spec.{ext} filename
# if pass a spec.{ext} filename, 
#  prints the corresponding .{ext} filename

function map_spec_name
    read input

    set regex 's/\.spec\.([^\.]*)$/.\1/g'
    if not string match -r '\.spec\.' $input > /dev/null
        set regex 's/\.([^\.]*)$/.spec.\1/g'
    end

    echo $input | sed -r $regex
end
