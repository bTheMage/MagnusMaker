testfunc=@echo $(1)

ifneq ($(silent),)
	testfunc=
endif

all:
	$(call testfunc,"Hello World!")