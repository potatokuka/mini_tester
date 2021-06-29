# mini_tester

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/potatokuka/mini_tester">
  </a>

  <h3 align="center">Mini Tester</h3>

  <p align="center">
    Easy to use tester to compare results of provided testcases between your minishell and bash!
    <br />
    <br />
    ·
    <a href="https://github.com/potatokuka/mini_tester/issues">Report Bug</a>
    ·
    <a href="https://github.com/potatokuka/mini_tester/issues">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

THIS IS NOT A REPLACEMENT FOR EVALS OR REAL TESTING,
THIS IS PURELY A QUICKER WAY TO RUN TESTS.
- DO NOT FAIL SOMEONE BECAUSE THEY FAILED THIS.
- DO NOT PASS SOMEONE BECAUSE THEY PASSED THIS.
- DO YOUR OWN TESTING, DO NOT BE A SHEEP.

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

Bash has to be installed and accessible through $PATH.  
Your minishell has to write its prompt to STDERR.

### Installation

1. Clone the repo anywhere
   ```sh
   git clone https://github.com/potatokuka/mini_tester.git
   ```
2. change `$MINISHELL_PATH` in `unit_tester.sh` to point to your minishell folder.


<!-- USAGE EXAMPLES -->
## Usage

`bash unit_tester.sh FILE [FILE2 FILE3 ..] [-e]`

Options:
 
  `-e` : Output of failing tests will be piped into `cat -e`

<!-- LICENSE -->
## License

Distributed under the MIT License.
