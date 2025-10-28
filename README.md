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

3. Create main and feat/cla branches

    git checkout -b feat/cla
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

4. Push committed files to feat/cla branch

    git push origin feat/cla

///////////////////////////////////////
//////  Installed Software  ///////////
///////////////////////////////////////

1. Git Bash
2. Icarus Verilog
3. GTKWave
4. Yosys

///////////////////////////////////////
////////  Running File  ///////////////
///////////////////////////////////////

1. Switching Terminal to Git Bash

    Press the unside down ^ by the + in the Terminal section of VSCode

    Select 'Git Bash'

2. For Simulation Script

    bash tb/run_sim.sh

3. For Waveform Script

    bash results/waves_cla.sh

4. For Synthesis Script

    bash synth/measure.sh