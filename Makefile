
.PHONY: clean distclean inputrc all
all:
	@

clean:
	$(RM) *~

inputrc: ## Generate variable/command info for readline config
	MAN_KEEP_FORMATTING=1 man 3 readline | awk -f bin/readline.awk

distclean: clean
	$(RM) *autoloads.el *loaddefs.el TAGS *.elc
