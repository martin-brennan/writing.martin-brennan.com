---
title: Git Shortcuts with FZF
date: 2017-04-20T19:30:00+10:00
author: Martin Brennan
layout: post
permalink: /git-shortcuts-with-fzf/
---

Today I started using [FZF](https://github.com/junegunn/fzf), which I'd heard of before but haven't found useful until now. It is a fuzzy file finder written in Go, which can be used to rapidly locate a file with the arbitrary string provided, starting with the current directory or a provided directory or STDIN.

Where I have found it most useful so far is alongside git. The first command I've set up an alias for is `git add`. I wanted to be able to add an individual file using git, though I didn't want to have to type out the full path of the file every time. This command gets all of the added, deleted, and modified files in the current repo and feeds them to `fzf`, where you can then search for and select the file you want. The selected file is then given to the `git add` command.

<!--more-->

```
git add "$({ git --no-pager diff --name-only; git ls-files --others --exclude-standard } | fzf)"
```

![gadd](/images/gadd.gif)

The second of these commands acts as the opposite, providing a shortcut for `git reset`. It will unstage a file from the list of staged files in git, which are passed to `fzf`.

```
git reset "$(git --no-pager diff --name-only --cached | fzf)"
```

Finally, there is a `git checkout` shortcut to quickly switch to a different branch. This function can just be defined in your `.bashrc` or `.zshrc` file, and called from an alias. It uses `fzf` again to search against a list of local branches that you can check out.

```
chk() {
  local branches branch
  branches=$(git branch -a) &&
  branch=$(echo "$branches" | fzf +s +m -e) &&
  git checkout $(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
}
```

![gadd](/images/chk.gif)

Finally, this command stages all of the untracked files in the current repo.

```
git add $(git ls-files -o --exclude-standard)
```