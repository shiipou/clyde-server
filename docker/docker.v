module docker

import net.http
import log

pub struct App {
	conn_uri    string
	api_version string
pub mut:
	file_log    log.Log
	cli_log     log.Log
}

pub struct Opts {
	conn_uri    string = 'file:///var/run/docker.sock'
	api_version string = 'v1.30'
}

pub fn new(opts Opts) ?App {
	return App{
		conn_uri: opts.conn_uri
	}
}

pub fn (app App) get_version() ?string {
	mut request := http.new_request(.get, '$app.conn_uri/$app.api_version/info', '') or {
		panic(err)
	}
	docker_info := request.do() or {
		panic(err)
	}
	if docker_info.status_code != 200 {
		panic('request status_code is $docker_info.status_code')
	}
}
