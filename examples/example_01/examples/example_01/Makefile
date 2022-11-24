##################################################
######//	MAGNUS MAKER	//####################
##################################################
# By Bernardo Maia Coelho 
# Version: 3.1.1 (24/11/2022)
MAGNUS_MAKER_VERSION="3.1.1"










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
CFLAGS := -MMD -MP
LDFLAGS := -MMD -MP


# MAKEFILE SETTINGS
MAKE := make
MKDIR := mkdir -p
RM := rm -fr
CLS := clear


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
	validation = @echo "Invalid mode." ; exit 1
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

ifeq ($(wildcard $(SRC)),)
	SRC:=.
endif

# COOL FUNCTIONS
getcod = $(subst .o,.c,$(subst $(TARDIR)/obj,$(SRC),$1))
getobj = $(subst .c,.o,$(subst $(SRC),$(TARDIR)/obj,$1))
# <UNUSED> : getdep = $(subst .c,.d,$(subst $(SRC),$(TARDIR)/dep,$1))



# EXPLORING THE FILE SYSTEM
# Iterate through the extensions : $(foreach extension,$(CEXTENSIONS), ... )
# Use a shell and do stuff stealthly : $(shell ...)
# Shell command to search recursively for code files : find ./$(SRC) | grep ".*\.$(extension)$$
# | -> Obs: use find ./$(SRC) | grep ".*\.c$" to search for .c files on your terminal.
CFILES := $(foreach extension,$(CEXTENSIONS),$(shell find ./$(SRC) | grep ".*\.$(extension)$$"))
OFILES := $(foreach cfile,$(CFILES),$(call getobj,$(cfile)))
DEPS := $(OFILES:.o=.d)

HPATH := $(strip $(INCLUSIONS))
HPATH += $(foreach folder,$(subst /.,,$(wildcard $(SRC)/*/.)),$(folder))
HPATH:=$(strip $(foreach hpath,$(HPATH),-I $(hpath)))










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
	@echo " "
	@echo "# ALL "
	@$(MAKE) build mode=release | $(FORMAT)
	@echo "/"
	@echo " "

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
	@echo " "
	@echo "# EXEC : $(mode)"
	@$(MAKE) build | $(FORMAT)
	@echo " " | $(IDENT)
	@echo "# JUST RUN : $(mode)" | $(IDENT)
	@$(MAKE) justrun | $(CROP) | $(IDENT) | $(IDENT)
	@echo "/" | $(IDENT)
	@echo "/"
	@echo " "

# Build the program.
build:
	@echo " "
	@$(validation)
	@echo "# BUILD : $(mode)" 
	@$(MAKE) $(TARDIR)/bin/$(EXE) | $(CROP) | $(IDENT)
	@echo "/"
	@echo " "

# Clean and rebuild.
fresh:
	@echo " "
	@echo "# FRESH: $(mode)"
	@$(MAKE) clean | $(FORMAT)
	@$(MAKE) build | $(FORMAT)
	@echo "/"
	@echo " "

# test
test:
	-@$(CLS)
	@echo " "
	@echo "# TEST : $(mode)"
	@$(MAKE) clean | $(FORMAT)
	@$(MAKE) exec  | $(FORMAT)
	@echo "/"
	@echo " "

# A good way to test your changes
quicktest qtest qt:
	@$(MAKE) fresh
	-@$(CLS)
	@$(MAKE) run | $(CROP)

# Makes a .gitignore for you
gitignore:
	@echo "/target" > .gitignore

# Updates and instal necessery packages with apt
update:
	@echo " "
	@echo "# UPDATE"

	@echo "Fetching for changes..." | $(IDENT)
	@echo " " 
	sudo apt update | $(IDENT)
	@echo " " | $(IDENT)

	@echo "Upgrading all packages..." | $(IDENT)
	@echo " " 
	sudo apt upgrade -y | $(IDENT)
	@echo " " | $(IDENT)

	@echo "Installing sed gnu build-essential (compilers and other stuff) ..." | $(IDENT)
	@echo " " 
	sudo apt install make build-essential -y | $(IDENT)
	@echo " " | $(IDENT)

	@echo "Installing linux cli utilities..." | $(IDENT)
	@echo " " 
	sudo apt-get install coreutils findutils grep -y | $(IDENT)
	@echo " " | $(IDENT)

	@echo "Installing zip..." | $(IDENT)
	@echo " "
	sudo apt-get install zip -y | $(IDENT)
	@echo " " | $(IDENT)

	@echo "Installing valgrind..." | $(IDENT)
	@echo " " 
	sudo apt install valgrind -y | $(IDENT)
	@echo " " | $(IDENT)

	@echo "Autoremoving unecessário packages..." | $(IDENT)
	@echo " " 
	sudo apt autoremove -y | $(IDENT)
	@echo " " | $(IDENT)

	@echo "ALL DONE!" | $(IDENT)
	@echo "/"
	@echo " "


# Calls valgrind
valgrind:
	@echo " "
	@echo "# VALGRIND EXECUTION : $(mode)"
	@valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose --log-file=$(TARDIR)/analysis/valgrind-out.txt ./$(TARDIR)/bin/$(EXE) | $(IDENT)
	@echo "/"
	@echo " "

# Show valgrind output.
valgrind-show:
	@echo " "
	@echo "# VALGRIND RESULTS : $(mode)"
	@cat "./$(TARDIR)/analysis/valgrind-out.txt" | $(IDENT)
	@echo "/"
	@echo " "

# Make fresh and analyse with valgrind.
analysis:
	@echo " "
	@$(validation)
	@echo "# ANALYSIS : $(mode)"
	@$(MAKE) fresh | $(FORMAT)
	@$(MKDIR) $(TARDIR)/analysis
	@$(MAKE) valgrind | $(FORMAT)
	@$(MAKE) valgrind-show | $(FORMAT)
	@echo "/"
	@echo " "

# Just checks the files and display a summary.
summary:
	$(validation)
	@echo " "
	@echo "# SUMMARY"
	@echo "# MODE: " 						| $(IDENT)
	@echo "> $(mode) " 						| $(IDENT)
	@echo " " 								| $(IDENT)
	@echo "# CFILES: " 						| $(IDENT)
	@echo "> $(CFILES) " 					| $(IDENT)
	@echo " " 								| $(IDENT)
	@echo "# DIRECTORIES TO BE INCLUDED: "	| $(IDENT)
	@echo "> $(HPATH) " 					| $(IDENT)
	@echo " " 								| $(IDENT)
	@echo "# EXPECTED DEPENDENCY FILES: " 	| $(IDENT)
	@echo "> $(DEPS) " 						| $(IDENT)
	@echo " " 								| $(IDENT)
	@echo "# EXPECTED OBJECT FILES: " 		| $(IDENT)
	@echo "> $(OFILES) " 					| $(IDENT)
	@echo " " 								| $(IDENT)
	@echo "/"
	@echo " "

# Hello, World!
hello hello-world:
	@echo "Hello, World!"

# Remove created files
clean:
	@echo " "
	@echo "# CLEAN : $(mode)"
	-@$(RM) -v $(TARDIR) | $(IDENT)
	@echo "/"
	@echo " "

# Clean and clear terminal
clear:
	-@$(CLS)
	@echo " "
	@echo "# CLEAR : $(mode)"
	@$(MAKE) clean | $(FORMAT)
	@echo "/"
	@echo " "
	@sleep 1
	-@$(CLS)

# Deletes target folder
fullclean:
	@echo " "
	@echo "# FULLCLEAN"
	-@$(RM) -v target | $(IDENT)
	@echo "/"
	@echo " "

# Deletes target folder and clear terminal
fullclear:
	-@$(CLS)
	@echo " "
	@echo "# FULLCLEAR"
	@$(MAKE) fullclean | $(FORMAT)
	@echo "/"
	@echo " "
	@sleep 1
	-@$(CLS)

# This target make 
bundle:
	@echo " "
	@echo "# BUNDLE "
	@$(MAKE) zip | $(FORMAT)
	@echo "/"
	@echo " "

# Makes the zip
zip:
	@echo " "
	@echo "# ZIP : $(mode)"
	@$(MKDIR) target/bundle | $(IDENT)
	@zip -r target/bundle/$(shell pwd | sed 's#.*/##').zip $(patsubst target,,$(wildcard *)) | $(IDENT)
	@echo "/"
	@echo " "

# Help!
help h: 
	@echo " "
	@echo "# HELP "
	@echo "> MagnusMaker $(MAGNUS_MAKER_VERSION) "| $(IDENT)
	@echo " " | $(IDENT)
	@echo "This makefile is somewhat smart. It will look for .h files inside the" | $(IDENT)
	@echo "src folder and its subfolders, but not the subfolders' subfolders. So" | $(IDENT)
	@echo "you can use #includes on your main.c with ease." | $(IDENT)
	@echo " " | $(IDENT)
	@echo "Use 'make build' to build and 'make justrun' to just run the the output" | $(IDENT)
	@echo "Use 'make build mode=release' to build on release mode, or just 'make all'." | $(IDENT)
	@echo "Use 'make run' to run the program on release mode." | $(IDENT)
	@echo "Set in the makefile the setting 'MAKE_IT_WORK' to true if you are having problens" | $(IDENT)
	@echo "to build on release mode, but try to avoid doing so." | $(IDENT)
	@echo "Use 'make bundle' to create a .zip file of the project to send it to family and friends! :)" | $(IDENT)
	@echo " " | $(IDENT)
	@$(MAKE) list-targets | $(FORMAT)
	@echo "/"
	@echo " "

list-targets:
	@echo " "
	@echo "# TARGET LIST"
	@echo " " | $(IDENT)
	@echo "> all : builds on release mode." | $(IDENT)
	@echo "> run : tries to run the release executable. If there is none, it tries the the debug executable." | $(IDENT)
	@echo " " | $(IDENT)
	@echo "> build : Build the program you can set the mode." | $(IDENT)
	@echo "> justrun (jrun) : Just runs the program on the current mode. " | $(IDENT)
	@echo "> exec (jrun) : Builds and execute. " | $(IDENT)
	@echo " " | $(IDENT)
	@echo "> clean : Removes the outputs of a compilation on a given mode." | $(IDENT)
	@echo "> clear : Just like clean, but clears the terminal after. " | $(IDENT)
	@echo "> fullclean : Removes the entire ./target/ folder." | $(IDENT)
	@echo "> fullclear : Just like fullclean, but clears the terminal after. " | $(IDENT)
	@echo " " | $(IDENT)
	@echo "> fresh : Removes the current output and build a fresh one." | $(IDENT)
	@echo "> test : Builds a fresh program and then tests it." | $(IDENT)
	@echo "> quick (qtest, qt) : Like test, but doens't display the process on the terminal." | $(IDENT)
	@echo " " | $(IDENT)
	@echo "> analyse : Analysis a fresh output program with valgrind." | $(IDENT)
	@echo "> valgrind : Analysis the current program with valgrind." | $(IDENT)
	@echo "> valgrind-show : Shows valgrind's output." | $(IDENT)
	@echo "> bundle : Creates a .zip file from the project for you so you can send it quickly." | $(IDENT)
	@echo " " | $(IDENT)
	@echo "> gitignore : makes a simple gitignore for you." | $(IDENT)
	@echo "> update : updates linux pacages using apt and install needed packages." | $(IDENT)
	@echo " " | $(IDENT)
	@echo "> summary : Use it to test what the makefile can see." | $(IDENT)
	@echo "> hello : Hello, World!." | $(IDENT)
	@echo "> help : Well... It helps." | $(IDENT)
	@echo "> list-targets: List some useful targets." | $(IDENT)
	@echo "/"
	@echo " "


# COMPILING OBJECT FILES
$(OFILES): $(filter %$(subst .o,.c,$(notdir $@)),$(CFILES))
	@echo "(cc) Compiling: $(notdir $@) "
	@$(MKDIR) $(dir $@) $(subst /obj/,/dep/,$(dir $@))
	@$(CC) $(CFLAGS) $(HPATH) -c $(call getcod,$@) -o $@ -MF "$(subst .o ,.d,$(subst /obj/,/dep/,$@) )"

# LINKING THE PROGRAM
#.SECONDEXPANSION: $(TARDIR)/bin/$(EXE)
$(TARDIR)/bin/$(EXE): $(OFILES)
	@echo "(ld) Linking object files and creating the executable: $(notdir $@) "
	@$(MKDIR) $(dir $@)
	@$(CC) $(LDFLAGS) $(HPATH) $(OFILES) -o $@ | $(IDENT)

# INCLUDING DEPENDENCY FILES
-include $(DEPS)