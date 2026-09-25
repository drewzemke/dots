function __jj_local_bookmarks
    jj bookmark list --ignore-working-copy -T 'if(!self.remote(), self.name() ++ "\n")' 2>/dev/null
end
