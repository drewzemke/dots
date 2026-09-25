# bookmarks, then change ids with descriptions
function __jj_revs
    jj bookmark list --ignore-working-copy --all-remotes -T 'if(self.remote() != "git", self.name() ++ if(self.remote(), "@" ++ self.remote()) ++ "\tbookmark\n")' 2>/dev/null
    jj log --ignore-working-copy --no-graph -r 'all()' -T 'self.change_id().short() ++ "\t" ++ self.description().first_line() ++ "\n"' 2>/dev/null
end
