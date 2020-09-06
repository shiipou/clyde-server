module api

import vweb

pub fn (mut app App) index() {
	app.vweb.json('{"success": true, "version": $app.clyde.get_info().version, "data":{}')
}
