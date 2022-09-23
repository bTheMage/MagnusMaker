# INCLUSÕES RELEVANTES INICIAIS
ifneq ($(wildcard .env),)
include .env
endif


# PARÂMETROS BOOLEANOS
release =


# CONSTANTES RELEVANTES
CC := g++
SC := glslc
JC := javac
EXE := main
SRC := src
SHADERS := shaders

### Vulkan flags
VK_CFLAGS := -std=c++17 -I. -I$(VULKAN_SDK_PATH)/include
VK_LDFLAGS := -L$(VULKAN_SDK_PATH)/lib `pkg-config --static --libs glfw3` -lvulkan

CFLAGS := -MD -MP -MMD
LDFLAGS := 



# DEFININDO FUNÇÕES DO SHELL
MKDIR:=mkdir -p
RM:=rm -rfv
MAKE:=make
CLEAR:=clear
ECHO:=echo
NEWLINE:=echo

# Modo verbose
ifeq ($(verbose),)
	MUTE:=> /dev/null
	ifeq ($(silent),)
		SAY:=> /dev/tty
	else
		SAY:=> /dev/null
	endif
endif



# DEFININDO A ESTRUTURA DE ARQUIVOS
ifeq ($(release),)
	DOMAIN:=target/debug
	OPT:=-O0
else
	DOMAIN:=target/release
	OPT:=-O3 -DRELEASE
endif
PROGRAM:=$(DOMAIN)/bin/$(EXE)


# FUNÇÕES IMPORTANTES
uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))


# ARQUIVOS
CFILES := $(wildcard $(SRC)/*.hpp) $(wildcard $(SRC)/*/*.hpp) $(wildcard $(SRC)/*/*/*.hpp) $(wildcard $(SRC)/*/*/*/*.hpp) $(wildcard $(SRC)/*/*/*/*/*.hpp) $(wildcard $(SRC)/*/*/*/*/*/*.hpp) $(wildcard $(SRC)/*.h) $(wildcard $(SRC)/*/*.h) $(wildcard $(SRC)/*/*/*.h) $(wildcard $(SRC)/*/*/*/*.h) $(wildcard $(SRC)/*/*/*/*/*.h) $(wildcard $(SRC)/*/*/*/*/*/*.h)
OFILES := $(subst $(SRC),$(DOMAIN)/obj,$(subst .hpp,.o,$(CFILES)))

HFILES := $(wildcard $(SRC)/*.hpp) $(wildcard $(SRC)/*/*.hpp) $(wildcard $(SRC)/*/*/*.hpp) $(wildcard $(SRC)/*/*/*/*.hpp) $(wildcard $(SRC)/*/*/*/*/*.hpp) $(wildcard $(SRC)/*/*/*/*/*/*.hpp) $(wildcard $(SRC)/*.h) $(wildcard $(SRC)/*/*.h) $(wildcard $(SRC)/*/*/*.h) $(wildcard $(SRC)/*/*/*/*.h) $(wildcard $(SRC)/*/*/*/*/*.h) $(wildcard $(SRC)/*/*/*/*/*/*.h)


VERT_SHADERS := $(wildcard $(SHADERS)/*.vert) $(wildcard $(SHADERS)/*/*.vert) $(wildcard $(SHADERS)/*/*/*.vert) 
FRAG_SHADERS := $(wildcard $(SHADERS)/*.frag) $(wildcard $(SHADERS)/*/*.frag) $(wildcard $(SHADERS)/*/*/*.frag) 
SFILES := $(VERT_SHADERS) $(FRAG_SHADERS)
SPVFILES := $(subst $(SHADERS),$(DOMAIN)/spv,$(foreach file,$(SFILES),$(file).spv))

ifeq ($(structures),bin)
	BINDIRS := $(call uniq,$(dir $(PROGRAM)))
else ifeq ($(structures),obj)
	OBJDIRS := $(call uniq,$(dir $(OFILES)))
else ifeq ($(structures),spv)
	SPVDIRS := $(call uniq,$(dir $(SPVFILES)))
endif

NEEDED_DIRS := $(BINDIRS) $(OBJDIRS) $(SPVDIRS)


# CONFIGURANDO TARGETS
.EXPORT_ALL_VARIABLES: all build structure run clean clear test release shaders
.PHONY: all build structure run clean clear test release shaders
.IGNORE: clean clear
.SILENT: all build structure run clean clear test release shaders



# TARGETS PRINCIPAIS
## Compila tudo se necessário.
all: 
	@$(MAKE) build ident='>>$(ident)' $(MUTE)
	@$(MAKE) shaders ident=">>$(ident)" $(MUTE)
	@$(ECHO) ">>$(ident) Deu tudo certo :)" $(SAY)

## Compila tudo se necessário, menos os shaders.
build: 
	@$(MAKE) structure structures=bin ident=">>$(ident)" $(MUTE)
	@$(MAKE) structure structures=obj ident=">>$(ident)" $(MUTE)
	@$(MAKE) $(PROGRAM) $(MUTE)
	@$(ECHO) ">>$(ident) O programa foi compilado com sucesso!" $(SAY)

## Cria diretórios se necessário.
structure: $(NEEDED_DIRS)
	@$(ECHO) ">>$(ident) A árvore de diretórios está nos conformes." $(SAY)

## Compila se necessário e roda o programa.
run:
	@$(MAKE) all ident=">>$(ident)" $(MUTE)
	$(NEWLINE) $(SAY)
	@./$(PROGRAM) $(SAY)

## Deleta os binários.
clean:
	@$(RM) $(DOMAIN)/obj $(DOMAIN)/bin $(DOMAIN)/spv $(SAY)
	@$(ECHO) ">>$(ident) Tudo limpo :)" $(SAY) 

## Deleta os binários e limpa a tela.
clear:
	@$(MAKE) clean ident=">>$(ident)" $(MUTE)
	@$(CLEAR) $(SAY) 

## Deleta o target inteiro.
fullclean fullClean full_clean:
	@$(RM) "target" $(SAY) 
	@$(ECHO) ">>$(ident) Absolutamente tudo limpo :)" $(SAY)

# Recompila tudo.
fresh:
	@$(MAKE) clean ident=">>$(ident)" $(MUTE)
	@$(MAKE) all ident=">>$(ident)" $(MUTE)
	@$(ECHO) ">>$(ident) A nova compilação foi um sucesso!" $(SAY) 

## Apenas roda o programa
justrun justRun just_run:
	@./$(PROGRAM) $(SAY)

## Recompila e roda o programa.
test:
	@$(MAKE) clear ident=">>$(ident)" $(MUTE)
	@$(MAKE) all ident=">>$(ident)" $(MUTE)
	$(CLEAR)
	@$(MAKE) justrun $(SAY)

## Compila uma versão otimizada do programa.
release:
	@$(MAKE) all release=true ident=">>$(ident)" $(MUTE)
	@$(ECHO) ">>$(ident) Versão release compilada com sucesso!" $(SAY) 

## Compila os shaders
shaders:
	@$(MAKE) structure structures=spv ident=">>$(ident)" $(MUTE)
	@$(MAKE) compile_shaders ident=">>$(ident)" $(MUTE)
	@$(ECHO) ">>$(ident) Shaders compilados com sucesso!" $(SAY) 

valgrind:
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose --log-file=target/debug/analysis/valgrind-out.txt ./target/debug/bin/$(EXE)

### Use essa keyword para gerar uma analysis do valgrind
analysis:
	$(MAKE) fresh
	$(MKDIR) target/debug/analysis/
	$(MAKE) valgrind
	@$(ECHO) ">>$(ident) Analise feita!" $(SAY) 

hello:
	@$(ECHO) 'Hello World!'

### Compacta tudo.
bundle:
	$(RM) target/bundle
	7z a target/bundle/bundle.zip src Makefile -y

### Linux only
gitignore:
	@$(ECHO) "/target" > .gitignore

# CRIANDO DIRETÓRIOS, SE NECESSÁRIO
$(NEEDED_DIRS):
	@$(MKDIR) $@

# TARGETS DE COMPILAÇÃO
## LINKANDO O POGRAMA PRINCIPAL
$(PROGRAM): $(OFILES)
	$(CC) $(CFLAGS) $(OPT) -o "$@" $(foreach file,$(OFILES),"$(file)") $(LDFLAGS)

## COMPILANDO CADA CPP
$(OFILES): $(subst $(DOMAIN)/obj,$(SRC),$(subst .o,.hpp,$@))
	$(CC) $(CFLAGS) $(OPT) -c -o "$@" "$(subst $(DOMAIN)/obj,$(SRC),$(subst .o,.hpp,$@))" $(LDFLAGS)

compile_shaders: $(SPVDIRS) $(SPVFILES)

$(SPVFILES): $(subst $(DOMAIN)/spv,$(SHADERS),$(subst .spv,,$@))
	$(SC) $(SFLAGS) -o "$@" "$(subst $(DOMAIN)/spv,$(SHADERS),$(subst .spv,,$@))"


# INCLUSÕES FINAIS
-include $(subst .h,.d,$(HFILES))