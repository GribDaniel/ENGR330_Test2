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

4. Push committed files to feat/rca branch

    git push origin feat/rca

// Updates

All of my commits were done through the terminal inside the root of my repo. I double-checked that
my work was organized correctly through the GitHub Desktop.

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

4. For Waveform Results:
    bash results/waves_rca.vcd
    bash results/waves_cla.vcd
    bash results/waves_pre.vcd

5. For Synthesis Script:
    bash synth/measure.sh

///////// MY STEPS /////////////
1. rca.sv

    Completed using structural code

    Based on slide 7 of Lecture 6

    1. Creation of a full adder using structural code
    2. Instantiating as a chain


2. cla.sv

    Completed using structural code

    Based on slides 9 - 31 of Lecture 6
    (Focus on slide 31)

    1. 4-bit cla blocks from structural code
    2. Instantiated as a chain


3. prefix.sv

    Completed using behavioral code

    Based on slides 33 - 36 on Lecture 6
    (Focus on slides 33 - 35)

    1. Calculate first propagate and generate
    2. Calculate the rest of the propagations and generates
    3. Carry propogation and find the Sum


4. tb_adder.sv

    Tests all of the adders through a Test Vector

5. run_sim.sh

    Generated using ChatGPT

    Runs all of the testbenches
    Provides the results for each adder
    Generates a waveform for each adder

    **MUST RUN IN GIT BASH**
        bash tb/run_sim.sh

    For waveforms: (choose individually)
        bash results/waves_rca.vcd
        bash results/waves_cla.vcd
        bash results/waves_prefix.vcd

6. measure.sh

    Generated using ChatGPT

    Synthesizes and roughly calculates timing and logic levels
    It also shows that all of the tasks passed expected
    *tried to use Yosys to accurately calculate, but it was not working
    *multiple attempts to correctly install for Windows and no version is currently available that works
    *possible to do on Vivado, but it was not possible with my given resources at home

    To run: (Git Bash)
        bash synth/measure.sh

    To see Timing Results:
        Go to /results/ directory to see each test

//////// WHAT WORKED /////////
1. Implementation of Adders in SystemVerilog
2. 2 Adders were made using structural Verilog
3. Simulation shows that the Adders are functional
4. Roughly Estimated Timing/Logic Levels
5. Testing using a Vector Test
6. GitHub
   1. Multiple branches
   2. Frequent commits
7. Functional README
8. Tag

/////// WHAT DIDN'T WORK ///////
1. Producing resource usage (only possible through vivado)
