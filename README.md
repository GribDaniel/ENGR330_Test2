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

1. Create main and feat/rca branches

    git checkout -b feat/rca
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


// Updates

All of my commits were done through the terminal inside the root of my repo. I double-checked that
my work was organized correctly through the GitHub
Desktop.

///////////////////////////////////////
/////  Software Installed  ////////////
///////////////////////////////////////

1. Git Bash – Version control & scripting  
2. Icarus Verilog – Compilation and simulation 
3. GTKWave – Waveform viewer  
4. Yosys – Logic synthesis and timing estimation

///////////////////////////////////////
////////  Running File  ///////////////
///////////////////////////////////////

// Open Git Bash in the Terminal

1. upside down ^ by the +

2. Git Bash

3. For Simulation Script:
    bash tb/run_sim.sh

4. For Synthesis Script:
    bash synth/measure.sh
