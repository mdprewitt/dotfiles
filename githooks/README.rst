### GitHooks

Git can run user defined hook scripts before/after certain git commands.
The scripts for these hooks are located in the `hooks` sub directory of the
Git directory which is normally `.git/hooks`.

See the docs for more info:

http://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks

For a complete list of hooks, look at `git help hooks`.

These hooks can be copied into the `.git/hooks` directory and do the following:

- `post-checkout` - Runs after the following git commands: `checkout`, `pull --rebase`.
  Checks for stale `.pyc` files and optionally deletes them.  If you've ever
  deleted a `.py` file but python still thought the file was there because of
  a leftover `.pyc` file, this is for you.

- `pre-commit` - Runs before `commit`.  Optionally aborts the commit if you add 
  a change that includes `pdb.set_trace()`.
