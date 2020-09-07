module docker

import log
import os
import time

pub struct App {
	uri         string
	api_version string
pub mut:
	file_log    log.Log
	cli_log     log.Log
}

pub struct Opts {
	uri         string = '/var/run/docker.sock'
	api_version string = 'v1.30'
}

pub fn new(opts Opts) ?App {
	mut app := App{
		uri: opts.uri
		api_version: opts.api_version
	}
	app.init()
	return app
}

fn (mut app App) init() {
	os.mkdir('logs')
	app.file_log = log.Log{}
	app.cli_log = log.Log{}
	app.file_log.set_level(.info)
	app.cli_log.set_level(.info)
	date := time.now()
	date_s := '$date.ymmdd()'
	app.file_log.set_full_logpath('./logs/docker_${date_s}.log')
}

// TODO: Find a way to remove this really cringe thing.. Burk !!
fn (app App) send_http(method, host, header, data string, is_socket bool) ?os.Result {
	if is_socket {
		return os.exec("curl --silent --fail --show-error -X $method --unix-socket $app.uri -H \'$header\' -d \'$data\' $host")
	} else {
		return os.exec("curl --silent --fail --show-error -X $method -H \'$header\' -d \'$data\' $host")
	}
}

pub fn (app App) send_get(path string) ?string {
	mut uri := app.uri
	mut is_socket := false
	if uri[0..1] == '/' {
		uri = 'http:'
		is_socket = true
	}
	mut result := app.send_http('GET', '$uri/$app.api_version/$path', 'Content-Type: application/json',
		'', is_socket) or {
		panic(err)
	}
	return result.output
}

pub fn (app App) send_post(path, data string) ?string {
	mut uri := app.uri
	mut is_socket := false
	if uri[0..1] == '/' {
		uri = 'http:'
		is_socket = true
	}
	mut result := app.send_http('POST', '$uri/$app.api_version/$path', 'Content-Type: application/json',
		data, is_socket) or {
		panic(err)
	}
	return result.output
}

pub fn (app App) get_version() ?string {
	mut result := app.send_get('info') or {
		panic(err)
	}
	return result
}

pub fn (app App) get_instances() ?string {
	mut result := app.send_get('containers/json') or {
		panic(err)
	}
	return result
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
