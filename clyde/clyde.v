module clyde

import v.vmod
import log
import docker
import os
import time

pub struct App {
mut:
	running  bool = false
	docker   docker.App
pub:
	version  string
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
	mut docker := docker.new(docker.Opts{
		uri: opts.conn_uri
	}) or {
		panic(err)
	}
	mut clyde := App{
		docker: docker
		version: 'v$vm.version'
	}
	return clyde
}

fn (mut app App) init() {
	os.mkdir('logs')
	app.file_log = log.Log{}
	app.cli_log = log.Log{}
	app.file_log.set_level(.info)
	app.cli_log.set_level(.info)
	date := time.now()
	date_s := '$date.ymmdd()'
	app.file_log.set_full_logpath('./logs/clyde_${date_s}.log')
	app.info('Starting Docker Clyde...')
	app.info('Clyde version: $app.version')
	app.run()
}

pub fn (mut app App) start() {
	app.running = true
	app.init()
}

fn (mut app App) run() {
	instances := app.docker.get_instances() or {
		panic(err)
	}
	println(instances)
}

pub fn (app App) is_running() bool {
	return app.running
}

fn (mut app App) upgrade(from, to string) ?bool {
	app.info('Upgrade from version $from to version $to')
	os.write_file('static/assets/version', app.version)
}

pub fn (mut app App) info(msg string) {
	app.file_log.info(msg)
	app.cli_log.info(msg)
}

pub fn (mut app App) warn(msg string) {
	app.file_log.warn(msg)
	app.cli_log.warn(msg)
}

pub fn (mut app App) error(msg string) {
	app.file_log.error(msg)
	app.cli_log.error(msg)
}
