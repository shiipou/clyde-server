module api

import vweb

pub fn (mut app App) index() {
	app.vweb.json('{"success": true, "version": "0.0.1", "data":{}')
}
