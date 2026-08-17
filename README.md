# ASICWRU Onboarding

This repository contains all of the information that we'll use for ASICWRU's technical onboarding. We'll have new members write a **single-cycle R32VI processor** in SystemVerilog. By the completion of this project, the design should be able to execute a one digit counter that starts from 0 and goes up to 9, and then goes back to 0 using the RISC-V assembly instructions.

The onboarding is welcome to all new members at CWRU and of all skill levels. This onboarding project may be challenging for beginners, but successfully finishing this project will be rewarding as it teaches you a lot of core concepts in digital design, design verification/emulation, and computer architecture. It will also give you a feel if this is something that you'd be interested in for a hobby or a career. If you've taken ECSE 281 or ECSE 301, this is a good step up and application of the knowledge you've accumulated from these classes. For the club's purpose, it will also help us become prepared for projects that are way more complex, and of course, resume-worthy.

There will be a GitHub template in this repository that you can clone on your computer and work on. More information about that below. This repository will contain some resources that could be helpful for you in finishing this project. You don't need to finish or read through all of them as some of them contain material beyond our scope.

You are also free to ask questions about onboarding such as help with the project or questions in the #onboarding-channel or you can just research this your own. This is a common beginner project and thus is heavily documented, you can

# Overview

A **processor** is a digital circuit that is capable of performing a specific task(s) by repeatedly receiving data and performing operations on them. There are different types of processors such as the CPU (Central Processing Unit) which is meant for general purpose and sequential tasks. Then, the GPU (Graphics Processing Unit) which is meant for rendering images, videos, and 3D models by being able to execute a lot of the same instructions in parallel. TPU (Tensor Processing Unit) which is used to accelerate tensor and matrix operations dedicated for machine learning. All of these processors have different architectures but fundamentally they all take data and instructions, then perform whatever those instructions they need to do onto that data, then return the results.

In our case, our design specifications will be:

**Single-cycle: the processor only performs one instruction per cycle
RV32I: short for RISC-V 32-Bit Integers


#
