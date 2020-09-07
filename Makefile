VC=v

build: clean fmt
	if ! [ -d build/ ]; then mkdir build; fi
	$(VC) -prod -obf -o build/clyde .

run: build
	build/clyde

debug: clean fmt
	v -live -color -cg -bv2 -o build/clyde run .

install: build
	if ! [ -d  ~/.vmodules/old ]; then mkdir -p ~/.vmodules/old >> /dev/null; fi
	if [ -d ~/.vmodules/old/docker_clyde ]; then rm -rf ~/.vmodules/old/docker_clyde >> /dev/null; fi
	if [ -d ~/.vmodules/docker_clyde ]; then mv ~/.vmodules/docker_clyde ~/.vmodules/old/docker_clyde >> /dev/null; fi
	mkdir -p ~/.vmodules/docker_clyde
	cp -r ./* ~/.vmodules/docker_clyde

clean:
	find . -name '*_test' | xargs rm -f
	rm -rf *.o *.o.tmp*

uninstall:
	[ -d ~/.vmodules/docker_clyde ] && rm -rf ~/.vmodules/docker_clyde ~/.vmodules/old/docker_clyde

fmt:
	find . -name "*.v" | xargs v fmt -w 

test: 
	v test ./tests/
