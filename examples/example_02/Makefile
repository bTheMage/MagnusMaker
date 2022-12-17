##################################################
######//	MAGNUS MAKER	//####################
##################################################
# By Bernardo Maia Coelho 
# Version: 3.2.0 (24/11/2022)
MAGNUS_MAKER_VERSION="3.2.1"










##################################################
######//	SETTINGS	//########################
##################################################
# Feel free to change those if you need.

# Defines how the makefile will optimize and compile the code. Change to 
STD_MODE := debug
# Set this to true if you need to make it work, no matter what.
# Make will disable optimization and -Wall -Werror on release mode.
MAKE_IT_WORK :=

# Which compiler are we using?
# EXE : The name of the output file. 
CC := gcc
EXE := main

# SRC : Were should we look for code files?
# INCLUSIONS : Were should we look for some extra headers?
# CEXTENSIONS : So, what is the extension of the code files?
SRC := src
INCLUSIONS:= src include
CEXTENSIONS := c cpp

# Raise the flags!
# C is for compiler flags and L is for linker flags.
CFLAGS := 
LDFLAGS :=


# MAKEFILE SETTINGS
MAKE := make
MKDIR := mkdir -p
RM := rm -fr
CLS := clear
ECHO := echo -e


# SHELL SETTINGS
SHELL:=/bin/bash










##################################################
######//	INICIALIZATION		//################
##################################################


# SAVING STACK
MK_STACK += $(lastword $(MAKEFILE_LIST))


# INPORTANT INCLUSIONS
ifneq ($(wildcard .env),)
include .env
endif


# PARAMETERS
# mode : {release, debug, none}
mode =
MODES_ENUM := release debug

# Setting standard mode
ifneq ($(mkstdmode),)
	mode := $(mkstdmode)
endif


# GLOBAL VARIABLES
# This variable will have an panic function if some erro has occurred. Else, it
# Should be empty.
validation =
warn =
TARDIR = target/$(mode)


# CONSTANTS
# Yes, it is somewhat tricky to get a constant to have an empty space on makefiles.
SPACE := $(subst ,, )


# SHELL CHEAT SHEET
# Just a quick shell action to crop the first and last line of text.
POP := sed '$$d'
SHIFT := sed '1d'
CROP := $(POP) | $(SHIFT)
IDENT := sed -e 's/^/|\ /'
FORMAT := $(CROP) | $(POP) | $(IDENT)



# PROCESSING PARAMETERS
ifeq ($(mode),)
	mode := debug
else ifeq ($(filter $(mode),$(MODES_ENUM)),)
	validation = @$(ECHO) "Invalid mode." ; exit 1
endif

ifeq ($(mode),release)
	ifeq ($(MAKE_IT_WORK),)
		CFLAGS += -O3 -Wall -Werror
		LDFLAGS += -O3 -Wall -Werror
	endif
else ifeq ($(mode),debug)
	CFLAGS += -O0 -g3
	LDFLAGS += -O0 -g3
endif

CFLAGS:=$(strip $(CFLAGS))
CFLAGS += -MD -MMD -MP
LDFLAGS += -MD -MMD -MP

# CHECKING THE PRESENCE OF A SOURCE DIRECTORY
ifeq ($(wildcard $(SRC)),)
	NO_SRC := true
	SRC := \.
	warn += \
		> WARNING: Could not found source directory. Assuming ./ is the source. \\n\
		- SUGGESTION: Put all of your code inside a src directory. It is more organized this way. \\n
endif


# COOL FUNCTION
ifdef NO_SRC
getobj = $(subst .c,.o,$(foreach file,$1,$(TARDIR)/obj/$(file)))
else
getobj = $(subst .c,.o,$(subst $(SRC),$(TARDIR)/obj,$1))
endif
getcod = $(subst .o,.c,$(subst $(TARDIR)/obj,$(SRC),$1))
# <UNUSED> : getdep = $(subst .c,.d,$(subst $(SRC),$(TARDIR)/dep,$1))

test_a:
	$(ECHO) '$(SRC)'


# EXPLORING THE FILE SYSTEM
# Iterate through the extensions : $(foreach extension,$(CEXTENSIONS), ... )
# Use a shell and do stuff stealthly : $(shell ...)
# Shell command to search recursively for code files : find ./$(SRC) | grep ".*\.$(extension)$$
# | -> Obs: use find ./$(SRC) | grep ".*\.c$" to search for .c files on your terminal.
ifdef NO_SRC
CFILES := $(foreach extension,$(CEXTENSIONS),$(shell find . | grep ".*\.$(extension)$$"))
else
CFILES := $(foreach extension,$(CEXTENSIONS),$(shell find ./$(SRC) | grep ".*\.$(extension)$$"))
endif
OFILES := $(foreach cfile,$(CFILES),$(call getobj,$(cfile)))
DEPS := $(OFILES:.o=.d)

HPATH := $(strip $(INCLUSIONS))
HPATH += $(foreach folder,$(subst /.,,$(wildcard $(SRC)/*/.)),$(folder))
HPATH := $(strip $(foreach hpath,$(HPATH),-I $(hpath)))








##################################################
######//	TARGETS		//#######################
##################################################


# CONFIGURANDO TARGETS
util_targets = all run justrun jrun exec build fresh test quicktest qtest qt gitignore update valgrind valgrind-show analysis summary hello hello-world clear fullclean fullclear bundle zip help
.EXPORT_ALL_VARIABLES: $(util_targets)
.PHONY: $(util_targets)
.IGNORE: clean clear fullclean fullclear
#.SILENT:


# Build the most optmized
all:
	@$(ECHO) " "
	@$(ECHO) "# ALL "
	@$(MAKE) build mode=release | $(FORMAT)
	@$(ECHO) "/"
	@$(ECHO) " "

# Run the most optimized
run:
ifneq ($(wildcard target/release/bin/$(EXE)),)
	./target/release/bin/$(EXE)
else
	./$(TARDIR)/bin/$(EXE)
endif

# Just run
justrun jrun:
	@./$(TARDIR)/bin/$(EXE)

# Euild and execute
exec:
	@$(ECHO) " "
	@$(ECHO) "# EXEC : $(mode)"
	@$(MAKE) build | $(FORMAT)
	@$(ECHO) " " | $(IDENT)
	@$(ECHO) "# JUST RUN : $(mode)" | $(IDENT)
	@$(MAKE) justrun | $(CROP) | $(IDENT) | $(IDENT)
	@$(ECHO) "/" | $(IDENT)
	@$(ECHO) "/"
	@$(ECHO) " "

# Build the program.
build:
	@$(ECHO) " "
	@$(ECHO) "# BUILD : $(mode)" 
	@$(validation)
	@$(ECHO) "$(warn)" | $(IDENT)
	@$(MAKE) $(TARDIR)/bin/$(EXE) | $(CROP) | $(IDENT)
	@$(ECHO) "/"
	@$(ECHO) " "

# Clean and rebuild.
fresh:
	@$(ECHO) " "
	@$(ECHO) "# FRESH: $(mode)"
	@$(MAKE) clean | $(FORMAT)
	@$(MAKE) build | $(FORMAT)
	@$(ECHO) "/"
	@$(ECHO) " "

# test
test:
	-@$(CLS)
	@$(ECHO) " "
	@$(ECHO) "# TEST : $(mode)"
	@$(MAKE) clean | $(FORMAT)
	@$(MAKE) exec  | $(FORMAT)
	@$(ECHO) "/"
	@$(ECHO) " "

# A good way to test your changes
quicktest qtest qt:
	@$(MAKE) fresh
	-@$(CLS)
	@$(MAKE) run | $(CROP)

# Makes a .gitignore for you
gitignore:
	@$(ECHO) "# Gitignore"
	@$(ECHO) "Creating a .gitignore" | $(IDENT)
	@$(ECHO) "target/" > .gitignore
	@$(ECHO) "/"

# Updates and instal necessery packages with apt
update:
	@$(ECHO) " "
	@$(ECHO) "# UPDATE"

	@$(ECHO) "Fetching for changes..." | $(IDENT)
	@$(ECHO) " " 
	sudo apt update | $(IDENT)
	@$(ECHO) " " | $(IDENT)

	@$(ECHO) "Upgrading all packages..." | $(IDENT)
	@$(ECHO) " " 
	sudo apt upgrade -y | $(IDENT)
	@$(ECHO) " " | $(IDENT)

	@$(ECHO) "Installing sed gnu build-essential (compilers and other stuff) ..." | $(IDENT)
	@$(ECHO) " " 
	sudo apt install make build-essential -y | $(IDENT)
	@$(ECHO) " " | $(IDENT)

	@$(ECHO) "Installing linux cli utilities..." | $(IDENT)
	@$(ECHO) " " 
	sudo apt-get install coreutils findutils grep -y | $(IDENT)
	@$(ECHO) " " | $(IDENT)

	@$(ECHO) "Installing zip..." | $(IDENT)
	@$(ECHO) " "
	sudo apt-get install zip -y | $(IDENT)
	@$(ECHO) " " | $(IDENT)

	@$(ECHO) "Installing valgrind..." | $(IDENT)
	@$(ECHO) " " 
	sudo apt install valgrind -y | $(IDENT)
	@$(ECHO) " " | $(IDENT)

	@$(ECHO) "Autoremoving unecessário packages..." | $(IDENT)
	@$(ECHO) " " 
	sudo apt autoremove -y | $(IDENT)
	@$(ECHO) " " | $(IDENT)

	@$(ECHO) "ALL DONE!" | $(IDENT)
	@$(ECHO) "/"
	@$(ECHO) " "


# Calls valgrind
valgrind:
	@$(ECHO) " "
	@$(ECHO) "# VALGRIND EXECUTION : $(mode)"
	@valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose --log-file=$(TARDIR)/analysis/valgrind-out.txt ./$(TARDIR)/bin/$(EXE) | $(IDENT)
	@$(ECHO) "/"
	@$(ECHO) " "

# Show valgrind output.
valgrind-show:
	@$(ECHO) " "
	@$(ECHO) "# VALGRIND RESULTS : $(mode)"
	@cat "./$(TARDIR)/analysis/valgrind-out.txt" | $(IDENT)
	@$(ECHO) "/"
	@$(ECHO) " "

# Make fresh and analyse with valgrind.
analysis:
	@$(ECHO) " "
	@$(validation)
	@$(ECHO) "# ANALYSIS : $(mode)"
	@$(MAKE) fresh | $(FORMAT)
	@$(MKDIR) $(TARDIR)/analysis
	@$(MAKE) valgrind | $(FORMAT)
	@$(MAKE) valgrind-show | $(FORMAT)
	@$(ECHO) "/"
	@$(ECHO) " "

# Just checks the files and display a summary.
summary:
	$(validation)
	@$(ECHO) " "
	@$(ECHO) "# SUMMARY"
	@$(ECHO) "# MODE: " 						| $(IDENT)
	@$(ECHO) "> $(mode) " 						| $(IDENT)
	@$(ECHO) " " 								| $(IDENT)
	@$(ECHO) "# CFILES: " 						| $(IDENT)
	@$(ECHO) "> $(CFILES) " 					| $(IDENT)
	@$(ECHO) " " 								| $(IDENT)
	@$(ECHO) "# DIRECTORIES TO BE INCLUDED: "	| $(IDENT)
	@$(ECHO) "> $(HPATH) " 					| $(IDENT)
	@$(ECHO) " " 								| $(IDENT)
	@$(ECHO) "# EXPECTED DEPENDENCY FILES: " 	| $(IDENT)
	@$(ECHO) "> $(DEPS) " 						| $(IDENT)
	@$(ECHO) " " 								| $(IDENT)
	@$(ECHO) "# EXPECTED OBJECT FILES: " 		| $(IDENT)
	@$(ECHO) "> $(OFILES) " 					| $(IDENT)
	@$(ECHO) " " 								| $(IDENT)
	@$(ECHO) "/"
	@$(ECHO) " "

# Hello, World!
hello hello-world:
	@$(ECHO) "Hello, World!"

# Remove created files
clean:
	@$(ECHO) " "
	@$(ECHO) "# CLEAN : $(mode)"
	-@$(RM) -v $(TARDIR) | $(IDENT)
	@$(ECHO) "/"
	@$(ECHO) " "

# Clean and clear terminal
clear:
	-@$(CLS)
	@$(ECHO) " "
	@$(ECHO) "# CLEAR : $(mode)"
	@$(MAKE) clean | $(FORMAT)
	@$(ECHO) "/"
	@$(ECHO) " "
	@sleep 1
	-@$(CLS)

# Deletes target folder
fullclean:
	@$(ECHO) " "
	@$(ECHO) "# FULLCLEAN"
	-@$(RM) -v target | $(IDENT)
	@$(ECHO) "/"
	@$(ECHO) " "

# Deletes target folder and clear terminal
fullclear:
	-@$(CLS)
	@$(ECHO) " "
	@$(ECHO) "# FULLCLEAR"
	@$(MAKE) fullclean | $(FORMAT)
	@$(ECHO) "/"
	@$(ECHO) " "
	@sleep 1
	-@$(CLS)

# This target make 
bundle:
	@$(ECHO) " "
	@$(ECHO) "# BUNDLE "
	@$(MAKE) zip | $(FORMAT)
	@$(ECHO) "/"
	@$(ECHO) " "

# Makes the zip
zip:
	@$(ECHO) " "
	@$(ECHO) "# ZIP : $(mode)"
	@$(MKDIR) target/bundle | $(IDENT)
	@zip -r target/bundle/$(shell pwd | sed 's#.*/##').zip $(patsubst target,,$(wildcard *)) | $(IDENT)
	@$(ECHO) "/"
	@$(ECHO) " "


#makefile debug kit
#log = $(shell $(ECHO) "$(1)" > /dev/tty)
#a = $(call log, hello3)
test2:
	@$(ECHO) 'hello 1'

# Help!
help h: 
	@$(ECHO) " "
	@$(ECHO) "# HELP "
	@$(ECHO) "> MagnusMaker $(MAGNUS_MAKER_VERSION) "| $(IDENT)
	@$(ECHO) " " | $(IDENT)
	@$(ECHO) "This makefile is somewhat smart. It will look for .h files inside the" | $(IDENT)
	@$(ECHO) "src folder and its subfolders, but not the subfolders' subfolders. So" | $(IDENT)
	@$(ECHO) "you can use #includes on your main.c with ease." | $(IDENT)
	@$(ECHO) " " | $(IDENT)
	@$(ECHO) "Use 'make build' to build and 'make justrun' to just run the the output" | $(IDENT)
	@$(ECHO) "Use 'make build mode=release' to build on release mode, or just 'make all'." | $(IDENT)
	@$(ECHO) "Use 'make run' to run the program on release mode." | $(IDENT)
	@$(ECHO) "Set in the makefile the setting 'MAKE_IT_WORK' to true if you are having problens" | $(IDENT)
	@$(ECHO) "to build on release mode, but try to avoid doing so." | $(IDENT)
	@$(ECHO) "Use 'make bundle' to create a .zip file of the project to send it to family and friends! :)" | $(IDENT)
	@$(ECHO) " " | $(IDENT)
	@$(MAKE) list-targets | $(FORMAT)
	@$(ECHO) "/"
	@$(ECHO) " "

list-targets:
	@$(ECHO) " "
	@$(ECHO) "# TARGET LIST"
	@$(ECHO) " " | $(IDENT)
	@$(ECHO) "> all : builds on release mode." | $(IDENT)
	@$(ECHO) "> run : tries to run the release executable. If there is none, it tries the the debug executable." | $(IDENT)
	@$(ECHO) " " | $(IDENT)
	@$(ECHO) "> build : Build the program on the current mode." | $(IDENT)
	@$(ECHO) "> justrun (jrun) : Just runs the program on the current mode. " | $(IDENT)
	@$(ECHO) "> exec : Builds and execute. " | $(IDENT)
	@$(ECHO) " " | $(IDENT)
	@$(ECHO) "> clean : Removes the outputs of a compilation on a given mode." | $(IDENT)
	@$(ECHO) "> clear : Just like clean, but clears the terminal after. " | $(IDENT)
	@$(ECHO) "> fullclean : Removes the entire ./target/ folder." | $(IDENT)
	@$(ECHO) "> fullclear : Just like fullclean, but clears the terminal after. " | $(IDENT)
	@$(ECHO) " " | $(IDENT)
	@$(ECHO) "> fresh : Removes the current output and build a fresh one." | $(IDENT)
	@$(ECHO) "> test : Builds a fresh program and then tests it." | $(IDENT)
	@$(ECHO) "> quick (qtest, qt) : Like test, but doens't display the process on the terminal." | $(IDENT)
	@$(ECHO) " " | $(IDENT)
	@$(ECHO) "> analyse : Analysis a fresh output program with valgrind." | $(IDENT)
	@$(ECHO) "> valgrind : Analysis the current program with valgrind." | $(IDENT)
	@$(ECHO) "> valgrind-show : Shows valgrind's output." | $(IDENT)
	@$(ECHO) "> bundle : Creates a .zip file from the project for you so you can send it quickly." | $(IDENT)
	@$(ECHO) " " | $(IDENT)
	@$(ECHO) "> gitignore : makes a simple gitignore for you." | $(IDENT)
	@$(ECHO) "> update : updates linux pacages using apt and install needed packages." | $(IDENT)
	@$(ECHO) " " | $(IDENT)
	@$(ECHO) "> summary : Use it to test what the makefile can see." | $(IDENT)
	@$(ECHO) "> hello : Hello, World!." | $(IDENT)
	@$(ECHO) "> help : Well... It helps." | $(IDENT)
	@$(ECHO) "> list-targets: List some useful targets." | $(IDENT)
	@$(ECHO) "/"
	@$(ECHO) " "


# COMPILING OBJECT FILES
$(OFILES): $(CFILES)
	@$(ECHO) "(cc) Compiling: $(notdir $@) "
	@$(MKDIR) $(dir $@) $(subst /obj/,/dep/,$(dir $@))
	@$(CC) $(CFLAGS) $(HPATH) -c $(call getcod,$@) -o $@ -MF "$(subst .o ,.d,$(subst /obj/,/dep/,$@) )"

# LINKING THE PROGRAM
#.SECONDEXPANSION: $(TARDIR)/bin/$(EXE)
$(TARDIR)/bin/$(EXE): $(OFILES)
	@$(ECHO) "(ld) Linking object files and creating the executable: $(notdir $@) "
	@$(MKDIR) $(dir $@)
	@$(CC) $(LDFLAGS) $(HPATH) $(OFILES) -o $@ | $(IDENT)

# INCLUDING DEPENDENCY FILES
-include $(DEPS)
