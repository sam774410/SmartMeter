var express = require('express');
var router = express.Router();

//模組化

//query all
router.get('/', function(req, res) {

	req.con.query('SELECT * from county', function (error, results, fields) {
		if (error)
			res.send(JSON.stringify({"status": 500, "error" : error}));
		if (results.length > 0)
			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
		else
			res.send(JSON.stringify({"status": 204, "success": false, "error": null, "response": "empty result"}));
	});
});




module.exports = router;
