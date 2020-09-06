module api

import vweb
import os
import time
import log
import clyde

struct App {
	clyde    clyde.App    [skip]
	host     string
	port     int
pub mut:
	vweb     vweb.Context [skip]
	file_log log.Log      [skip]
	cli_log  log.Log      [skip]
}

pub struct Opts {
	conn_uri string = '/var/run/docker.sock'
	api      bool = false
	api_host string = '127.0.0.1'
	api_port int = 80
}

pub fn new(clyde clyde.App, opts Opts) ?&App {
	return App{
		clyde: clyde
		host: opts.api_host
		port: opts.api_port
	}
}

pub fn (app App) start() {
	println('Starting Docker Clyde...')
	println('Clyde version is : $app.clyde.get_info().version')
	vweb.run<App>(app.port)
}

pub fn (mut app App) init_once() {
	os.mkdir('logs')
	app.file_log = log.Log{}
	app.cli_log = log.Log{}
	app.file_log.set_level(.info)
	app.cli_log.set_level(.info)
	date := time.now()
	date_s := '$date.ymmdd()'
	app.file_log.set_full_logpath('./logs/api_${date_s}.log')
	app.info('init_once()')
}

pub fn (mut app App) init() {
	version := os.read_file('static/assets/version') or {
		app.clyde.get_info().version
	}
	if version != app.clyde.get_info().version {
	}
}

fn (mut app App) upgrade(from, to string) ?bool {
	app.info('Upgrade from version $from to version $to')
	os.write_file('static/assets/version', app.clyde.get_info().version)
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
