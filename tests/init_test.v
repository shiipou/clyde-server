module main

import v.vmod
import clyde
import api

fn test_clyde_init() {
	vm := vmod.decode(@VMOD_FILE) or {
		panic(err)
	}
	mut clyde := clyde.new(clyde.Opts{}) or {
		panic(err)
	}
	clyde.start()
	assert clyde.version == vm.version
}

fn test_clyde_api_init() {
	vm := vmod.decode(@VMOD_FILE) or {
		panic(err)
	}
	mut clyde := clyde.new(clyde.Opts{}) or {
		panic(err)
	}
	clyde.start()
	mut clyde_api := api.new(clyde, api.Opts{}) or {
		panic(err)
	}
	clyde_api.start()
	assert clyde.version == vm.version
}
