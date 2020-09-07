module api

import vweb
import os
import time
import log
import clyde

struct App {
	host     string
	port     int
mut:
	clyde    clyde.App
	running  bool = false
pub mut:
	vweb     vweb.Context
	file_log log.Log
	cli_log  log.Log
}

pub struct Opts {
	conn_uri string = '/var/run/docker.sock'
	api      bool = false
	api_host string = '127.0.0.1'
	api_port int = 80
}

pub fn new(opts Opts) ?App {
	return App{
		host: opts.api_host
		port: opts.api_port
	}
}

pub fn (mut app App) start() {
	app.running = true
	vweb.run<App>(app.port)
}

pub fn (mut app App) init_once() {
	app.info('Init Clyde API...')
	os.mkdir('logs')
	app.file_log = log.Log{}
	app.cli_log = log.Log{}
	app.file_log.set_level(.info)
	app.cli_log.set_level(.info)
	date := time.now()
	date_s := '$date.ymmdd()'
	app.file_log.set_full_logpath('./logs/api_${date_s}.log')
	app.clyde = clyde.new(clyde.Opts{}) or {
		panic(err)
	}
	app.run()
}

pub fn (mut app App) init() {
}

fn (mut app App) run() {
	app.info('Starting Clyde API...')
	if !app.clyde.is_running() {
		app.info('Clyde is not running so API will start it.')
		app.clyde.start()
	}
}

pub fn (app App) get_clyde() clyde.App {
	return app.clyde
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
