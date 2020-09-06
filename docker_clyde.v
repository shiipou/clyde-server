module main

import clyde
import api

fn main() {
	clyde := clyde.new(clyde.Opts{}) or {
		panic(err)
	}
	api := api.new(clyde, api.Opts{}) or {
		panic(err)
	}
	api.start()
}
