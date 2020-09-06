module clyde

import v.vmod
import log
import docker

pub struct App {
mut:
	running  bool = false
	docker   docker.App
pub:
	info     vmod.Manifest
pub mut:
	file_log log.Log
	cli_log  log.Log
}

pub struct Opts {
	conn_uri string = '/var/run/docker.sock'
}

pub fn new(opts Opts) ?App {
	vm := vmod.decode(@VMOD_FILE) or {
		panic(err)
	}
	docker := docker.new(docker.Opts{
		conn_uri: opts.conn_uri
	}) or {
		panic(err)
	}
	clyde := App{
		docker: docker
		info: vm
	}
	return clyde
}

pub fn (mut app App) start() {
	app.running = true
	println('Starting Docker Clyde...')
	println('Clyde version is : $app.info.version')
	app.docker.get_version()
}

pub fn (app App) get_info() vmod.Manifest {
	return app.info
}

pub fn (app App) is_running() bool {
	return app.running
}
