
.PHONY: list-open-issues

list-open-issues:
	@grep -L '^status: done' issues/*

