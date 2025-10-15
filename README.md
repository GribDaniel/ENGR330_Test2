////////////////////////////////////
// Git/Version Control - My Steps //
////////////////////////////////////

1. Initialized repo
   
   git init
   git remote add origin https://github.com/GribDaniel/ENGR330_Test2.git

2. Confirm repo connection 

    git remote -v

origin  https://github.com/GribDaniel/ENGR330_Test2.git (fetch)
origin  https://github.com/GribDaniel/ENGR330_Test2.git (push)

3. Create main and develop branches

    git checkout -b develop
    git checkout -b main


////////////////////////////////////
// Pushing Commits to GitHub Repo //
////////////////////////////////////

1. Double-checking status changes

    git status

2. Add changed files to be committed

    git add .

3. Commit changed files

    git commit -m "<Insert Comment here>"

4. Push committed files to main branch

    git push origin main

