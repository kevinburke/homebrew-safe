diff:
	cd ../../homebrew/homebrew-core && git pull origin master
	diff $(file) ../../homebrew/homebrew-core/$(file)
