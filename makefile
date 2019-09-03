#projects src files are in ./src
SRC_DIR := ./src

#object files will be placed in ./obj
OBJ_DIR := ./obj

#test version of program object files will be placed in ./test_obj. (test version uses same src folder)
TEST_OBJ_DIR := ./test_obj

#the final name of the executable
EXE_NAME := main

#the final name of the test executable
TEST_EXE_NAME := test_main

#this finds all source files ending in .cpp but excludes test_main.cpp (this has its own main function which will conflict with the standard one)
SRC_FILES := $(filter-out $(SRC_DIR)/test_main.cpp, $(wildcard $(SRC_DIR)/*.cpp))

#conversely, this finds all source files ending in .cpp but excludes main.cpp
TEST_SRC_FILES := $(filter-out $(SRC_DIR)/main.cpp, $(wildcard $(SRC_DIR)/*.cpp))

#this lists all object files by substituting the extension in all the source files
OBJ_FILES := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRC_FILES))

#same as above, but for test object files
TEST_OBJ_FILES := $(patsubst $(SRC_DIR)/%.cpp,$(TEST_OBJ_DIR)/%.o,$(TEST_SRC_FILES))


#give the ip address and user account of the beaglebone black for ssh purposes - typical defaults are given here
SSHIP := 192.168.7.2
USER := debian


#point to the desired target location for the program on the beaglebone (note that ~ does NOT refer to local home directory, but home directory of user specified above in USER variable)
TARGETLOC = ~/projects/gtestproject


#point to the g++ linaro cross-compiler here, first g++, then the includes folder
COMPILER = ${HOME}/crosscomp/gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++
INCLUDES = ${HOME}/crosscomp/gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf/include

#then the cross-compiled libgtest and libgtest_main libraries (only if you want to use googletest)
TEST_LIB = ${HOME}/crosscomp/gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf/lib/libgtest.a ~/crosscomp/gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf/lib/libgtest_main.a


#main rules - ignores test_main.cpp and does not build test_main exe

all: build send run #default target builds main exe then runs remotely over ssh

build: $(EXE_NAME) #build the executable

$(EXE_NAME): $(OBJ_FILES) #once all object files are up-to-date
	${COMPILER} -g -o $@ $^ #link them all using g++ linaro into the executable
	
send: #comms commands
	-ssh -q $(USER)@$(SSHIP) "rm -rf ${TARGETLOC}"  #delete the target folder on the beaglebone, ignores if error
	ssh -q $(USER)@$(SSHIP) "mkdir ${TARGETLOC}"  #recreate the target folder
	scp "./$(EXE_NAME)" "$(USER)@$(SSHIP):${TARGETLOC}" #secure copy the executable over


$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp #builds the given object file if the corresponding source file has changed
	${COMPILER} -I"${INCLUDES}" -g -c -o $@ $< #-g gives gdb support

run: #runs the program remotely using ssh
	ssh $(USER)@$(SSHIP) "${TARGETLOC}/${EXE_NAME}"


#test rules - ignores main_run.cpp and does not build main_run exe, instead building test exe

all_test: build_test send_test run_test #invoking "make all_test" builds the text exe then runs remotely over ssh

build_test: $(TEST_EXE_NAME) #build the test executable

$(TEST_EXE_NAME): $(TEST_OBJ_FILES) #once all test object files are up-to-date
	${COMPILER} -pthread -g -o $@ $^ ${TEST_LIB} #link them all using g++ linaro into the test executable. pthread library support is needed for googletest
	
send_test: #comms commands
	-ssh -q $(USER)@$(SSHIP) "rm -rf ${TARGETLOC}"   #delete the target folder on the beaglebone, ignores if error
	ssh -q $(USER)@$(SSHIP) "mkdir ${TARGETLOC}"  #recreate the target folder
	scp "./$(TEST_EXE_NAME)" "$(USER)@$(SSHIP):${TARGETLOC}" #secure copy the test executable over

$(TEST_OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp   #builds the given test object file if the corresponding source file has changed
	${COMPILER} -I"${INCLUDES}" -g -c -o $@ $< #-g gives gdb support

run_test: #runs the test program remotely using ssh
	ssh $(USER)@$(SSHIP) "${TARGETLOC}/${TEST_EXE_NAME}"

#clean stuff

clean: #just wipes both exes and both object folders, ignores any errors
	-rm "./$(EXE_NAME)"
	-rm -rf "./$(OBJ_DIR)/*"
	-rm "./$(TEST_EXE_NAME)"
	-rm -rf "./$(TEST_OBJ_DIR)/*"
