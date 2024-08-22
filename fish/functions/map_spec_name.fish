#!/usr/bin/env fish
#
# if passed a .ts, .tsx, .js, or .jsx filenmae, creates a .spec.{ext} file and 

# TODO: if there's already `.spec` in the name, remove it
set regex 's/\.([^\.]*)$/.spec.\1/g'

function map_spec_name
    read input
    echo $input | sed -r $regex
end
