# Beaglebone Black remote and gtest example


INTRODUCTION

This is a simple project that shows you how to cross-compile and remotely send a program to the Beaglebone Black. It can also show you how to produce a corresponding cross-compiled test program using googletest.

Moreover, it can be seen as a gentle introduction to "make".

REQUIREMENTS

If all you want to do is cross-compile the main program, you need to have the Linaro g++ ARM cross-compiler built and available on your system. 

If you want to cross-compile the corresponding test program, you also need to have googletest cross-compiled for the ARM architecture.

If you want to automatically send and execute either the main program, or the test program remotely, your Beaglebone Black needs to be connected to your network. You also need to enable "passphraseless"-SSH as described in the top answer on this post:

https://serverfault.com/questions/241588/how-to-automate-ssh-login-with-password


HOW TO USE

To simply build the main program, you need to appropriately set the following two variables in the makefile: "COMPILER" "INCLUDES" (examples are given in the file for reference). Then run "make build" to produce the executable.

To build the test program, you also need to set the following variable in addition to the above two: "TEST_LIB". This variable should point to both the cross-compiled "libgtest.a", and the cross-compiled "libgtest_main.a". Inside the folder pointed to by the INCLUDES variable, there should be a "gtest" folder containing all of the gtest headers (e.g. INCLUDES/gtest/gtest.h as well as all other necessary headers) 

To send or run either program over SSH, you should also set the following three variables in the makefile "SSHIP" "USER" "TARGETLOC". 

Running "make" or "make all" will build, send, and execute the main program remotely over ssh. 

Running "make send" or "make run" either only sends or only runs the main program respectively

Running "make test_all" will build, send, and execute the test program remotely over ssh.

Running "make send_test" or "make run_test" either only sends or only runs the test program respectively.