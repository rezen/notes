# git

- Files changes in a commit  
  `git diff-tree --no-commit-id --name-only -r c06d5186ed7`
- Last commit files changes  
  `git rev-parse HEAD | xargs -I {} git diff-tree --no-commit-id --name-only -r {}`
- Current files  
  `git status -s | grep php | sed 's/^ *//' | cut -d' ' -f2`
- Pipe to lint quickly  
  `xargs -I {} php -l  {}`  
  `git rev-parse HEAD | xargs -I {} git diff-tree --no-commit-id --name-only -r {} | xargs -I {} php -l  {}`
- Php file changes in a merge  
  `git log -1 --name-only | grep '.php' | xargs -I{} php -l  {}`
- Show files changes between branches  
  `git diff remotes/origin/master remotes/origin/security-tweak --name-only`
- Git show pending merges  
`git show-ref | grep merge | cut -d' ' -f1 | xargs -I{} git show {}`