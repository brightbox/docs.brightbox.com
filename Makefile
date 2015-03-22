all: compile

check:
	bundle exec nanoc check --no-color internal_links

compile:
	bundle exec nanoc compile --no-color

