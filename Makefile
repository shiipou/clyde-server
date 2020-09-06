VC=v

build: clean fmt
	$(VC) -gc docker_clyde.v >> /dev/null

install: build
	[ -d ~/.vmodules/old/docker_clyde ] && rm -rf ~/.vmodules/old/docker_clyde && mkdir -p ~/.vmodules/old >> /dev/null
	[ -d ~/.vmodules/docker_clyde ] && mv ~/.vmodules/docker_clyde ~/.vmodules/old/docker_clyde >> /dev/null
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
