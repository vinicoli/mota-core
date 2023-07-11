<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][vini-linkedin-url]

# Mota-Core Processor in VHDL
Microprocessor design for the Design System's course.

+ Universidade Federal do Rio Grande do Norte
+ Departamento de Engenharia Elétrica
+ ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
+ Professor: Victor Araujo Ferraz
+ Students:
    - Cintia Mafra
    - Vinícius Oliveira
+ July 2023


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#the-mota-core-processor">The mota-core Processor</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#usage">Usage</a></li>
        <li><a href="#how-the-code-runs">How the code runs</a></li>
      </ul>
    </li>
    <!-- <li><a href="#usage">Usage</a></li> -->
    <!-- <li><a href="#roadmap">Roadmap</a></li> -->
    <li><a href="#suported-instructions">Suported Instructions</a></li>
    <li><a href="#components">Components</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

## The mota-core Processor
![The mota-core Processor](https://github.com/vinicoli/mota-core/assets/56003318/925e16ca-d7b8-4337-8be3-91a3cf278025)

### Built With

* [![VHDL][VHDL-shield]][VHDL-url]
* [![Quartus][Quartus-shield]][Quartus-url]
* [![Git][Git-shield]][Git-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Getting Started
To get a local copy up and running follow these simple example steps below.

### Prerequisites
To proceed with the installation, it is necessary to have the following pre-installed software on your machine:
* [Quartus][quartus-url]
* [Git][Git-url]

### Installation
1. In a Git bash or terminal go to your workspace by typing:
   ```bash
   cd ~/workspace
   ```
2. Clone the repo:
   ```bash
   git clone https://github.com/vinicoli/mota-core.git
   ```
3. Go to the project workspace:
   ```bash
   cd ~/workspace/mota-core
   ```
4. Create a project in Quartus and add all the .vhd files to the project.
5. Set the main.vhd as top level.

### Usage
1. Place binary mota-core instructions in a file `instructions.txt` and place it in the same directory as these .vhd files. The mota-core compiler will read the binary instructions from this file and run it after the first clock cycle.
3. On the modelsim command line, run `source setup.tcl`. This is a small script that automatically compiles the code, generates the simulation (though it doesn't run it), and adds the objects into the wave view. If this doesn't work, then you can just compile and run the normal way.

### How the code runs
The first clock cycle is always dedicated to reading the code from `instructions.txt` and saving it into the instruction memory (found in `instruction_memory.vhd`). It has nothing to do with the processor itself. This is just a preliminary action. Starting on the second clock cycle is when the program runs.

Every clock cycle after the first reads an instruction from the instruction memory and increments the program counter accordingly. The program will continue to run until the pc has reached an address greater than the address of the last instruction in memory. The instruction, data, and register memory will still persist after the program ends and will only change if it is overwritten, or the simulation ends.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ## Suported Instructions
| Instruction | Format | Operation | Syntax |
|-------------|--------|-----------|--------|
| Add | R | R[rd] = R[rs] + R[rt] | add $rd, $rs, $rt |
| Add immediate | I | R[rt] = R[rs] + immed. | addi $rt, $rs, immed. |
| And | R | R[rd] = R[rs] & R[rt] | and $rd, $rs, $rt |
| Branch On Equal | I | if (R[rs]==R[rt]) PC=PC+4+BranchAddr | beq $rs, $rt, BranchAddr |
| Branch On Not Equal | I | if (R[rs]!=R[rt]) PC=PC+4+BranchAddr | bne $rs, $rt, BranchAddr |
| Jump | J | PC=JumpAddr | j JumpAddr |
| Or | R | R[rd] = R[rs] \| R[rt] | or $rd, $rs, $rt |
| Set Less Than | R | R[rd] = (R[rs] < R[rt]) ? 1 : 0 | slt $rd, $rs, $rt | -->

## Suported Instructions
![ISA-mota-core](https://github.com/vinicoli/mota-core/assets/56003318/1b54e822-39c5-4376-b520-711d76e2307c)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Components
Details of the major parts of the processor.

Already Implemented:

- smallmux.vhd
  - Simple 2x1 multiplexer implementation.
- bigmux.vhd
  - Simple 3x1 multiplexer implementation.
- pc.vhd
  - The program counter for pointing to the next instruction.
- sp.vhd
  - The stack pointer register for pointing to the subroutine next instruction.
- adder.vhd
  - Used to naturally increment PC.
- register_file.vhd
  - The block of sixteen 16-bit registers.

To be implemented:
- main.vhd
  - The main script that is run. This is what should be selected as the design unit when simulating.
- instruction_memory.vhd
  - The block of memory that reads the instructions from a file and saves it into a block of memory.
- control.vhd
  - Sets all the flags coming out of the controller appropriately given the 6-bit opcode
- alu.vhd
  - The ALU that performs specific operations given the input of the ALU control.
- buffer.vhd
  - The in/out buffer interface.
- data_memory.vhd
  - Sample text

<!-- ## Todo
1. Add `lw` and `sw` support.
2. Profit.
3. Ayy lmao. -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## License

MIT License

Copyright (c) 2023 Vinicius Oliveira, Cintia Mafra

This project is licensed under the MIT License. Please see the [LICENSE](LICENSE) file for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contribution
Contributions to this project are welcome! If you would like to contribute, please follow these guidelines:

+ Fork the repository and create your branch from the main branch.
+ Make your changes, ensuring they adhere to the project's coding conventions and guidelines.
+ Test your changes thoroughly.
+ Submit a pull request, providing a clear description of your changes and the problem they solve.

We appreciate your contributions in the form of bug reports, feature requests, or code improvements.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contact
For any inquiries or questions regarding this project, please feel free to reach out to us:

+ Vinícius Oliveira - vinicius.ee.ufrn@gmail.com - [Github][vini-github-url] - [LinkedIn][vini-linkedin-url] - [Instagram][vini-instagram-url]
+ Cintia Mafra - cintia.mafra.091@ufrn.edu.br - [Github][cintia-github-url] - [LinkedIn][cintia-linkedin-url] - [Instagram][cintia-instagram-url]

Project Link: [https://github.com/vinicoli/mota-core](https://github.com/vinicoli/mota-core)

We are happy to assist you and discuss any feedback or collaboration opportunities.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/vinicoli/mota-core.svg?style=for-the-badge
[contributors-url]: https://github.com/vinicoli/mota-core/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/vinicoli/mota-core.svg?style=for-the-badge
[forks-url]: https://github.com/vinicoli/mota-core/network/members
[stars-shield]: https://img.shields.io/github/stars/vinicoli/mota-core.svg?style=for-the-badge
[stars-url]: https://github.com/vinicoli/mota-core/stargazers
[issues-shield]: https://img.shields.io/github/issues/vinicoli/mota-core.svg?style=for-the-badge
[issues-url]: https://github.com/vinicoli/mota-core/issues
[license-shield]: https://img.shields.io/github/license/vinicoli/mota-core.svg?style=for-the-badge
[license-url]: https://github.com/vinicoli/mota-core/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555

[vini-linkedin-url]: https://linkedin.com/in/vinicoli
[vini-github-url]: https://github.com/vinicoli
[vini-instagram-url]: https://www.instagram.com/vini.coli/

[cintia-linkedin-url]: https://www.linkedin.com/in/c%C3%ADntia-mafra-4a040618a/
[cintia-github-url]: https://github.com/cintiamafra2
[cintia-instagram-url]: https://www.instagram.com/cintimafra/

[Git-shield]: https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white
[Git-url]: https://git-scm.com/
[quartus-shield]: https://img.shields.io/badge/Quartus-5F4BB6?style=for-the-badge&logo=altera&logoColor=white
[quartus-url]: https://www.intel.com.br/content/www/br/pt/products/details/fpga/development-tools/quartus-prime.html
[VHDL-shield]: https://img.shields.io/badge/VHDL-4285F4?style=for-the-badge&logo=vhdl&logoColor=white
[VHDL-url]: https://vhdlguide.readthedocs.io/en/latest/
