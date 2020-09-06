module api

import vweb
import json

pub fn (mut app App) index() {
	app.vweb.json(json.encode(app))
}
