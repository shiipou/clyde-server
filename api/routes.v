module api

import vweb

[live]
pub fn (mut app App) index() {
	app.vweb.json('{"success": true, "version": "0.0.1", "data":{}}')
}

['/users']
pub fn (mut app App) get_user() {
	app.vweb.json('{"success": true, "version": "0.0.1", "data":{id:1}}')
}
