# Docker container for gem5 simulator with x86 architecture for educational purposes

The full documentation on gem5 can be found [here](https://www.gem5.org/documentation/).

## Prerequisites

- Docker installed on your machine
- Git installed on your machine

After cloning this repository, go to the repository directory and follow the instructions below.

## How to build and run the docker container

This command will build the docker container with the name orgb_gem5:

```bash
docker build -t orgb_gem5 .
```

After that, you can run the docker container with the following command:

```bash
docker run -u ${UID}:${GID} -v ${PWD}/orgb_progs:/gem5/orgb_progs -v ${PWD}/orgb_configs:/gem5/orgb_configs -v ${PWD}/m5out:/gem5/m5out --rm -it orgb_gem5
```

If you want to build and run the docker container in a single command, run the following command:

```bash
docker build -t orgb_gem5 . && docker run -u ${UID}:${GID} -v ${PWD}/orgb_progs:/gem5/orgb_progs -v ${PWD}/orgb_configs:/gem5/orgb_configs -v ${PWD}/m5out:/gem5/m5out --rm -it orgb_gem5
```

For the first time, the docker container will be built and run. After that, the container will be run.

## How to run gem5 simulator

This container already provides the gem5 simulator for x86 architecture. To run the gem5 simulator, run the following command:

```bash
./gem5 orgb_configs/simulate.py run-benchmark -c tests/test-progs/hello/bin/x86/linux/hello
```

After each run, the results will be saved in the m5out directory.

## Compile a program for gem5 simulator

To compile a program for gem5 simulator, run the following command:

```bash
gcc orgb_progs/hello.c -o orgb_progs/hello -static
```

All programs compiled for gem5 simulator must use the -static flag.

After that, you can run the program on gem5 simulator with:

```bash
./gem5 orgb_configs/simulate.py run-benchmark -c orgb_progs/hello
```

## Changing the gem5 simulator CPU and Cache configuration

To change the gem5 simulator CPU and Cache configuration, edit the orgb_configs/systems/cpus/MyO3CPU.py for the CPU configuration and orgb_configs/systems/caches/MyCache.py for the Cache configuration.

## How to build gem5 simulator for another architecture

To manually build gem5 simulator inside the docker container in another desired architecture, run the following command:

```bash
scons build/$GEM5_ARCH/gem5.opt -j$(nproc) && RUN ln -s build/$GEM5_ARCH/gem5.opt ./gem5.$GEM5_ARCH
```

Substitute $GEM5_ARCH with the desired architecture. For example, to build gem5 for ARM architecture, run the following command:

```bash
scons build/ARM/gem5.opt -j$(nproc) && RUN ln -s build/ARM/gem5.opt ./gem5.ARM
```
