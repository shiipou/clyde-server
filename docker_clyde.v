module main

import api

fn main() {
	mut api := api.new(api.Opts{}) or {
		panic(err)
	}
	api.start()
}
