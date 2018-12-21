var express = require('express');
var router = express.Router();


// router.post('/', function(req, res) {

// 	var Day = req.body.Day;

// 	req.con.query('SELECT Name,Supply FROM tmpsupplydata WHERE Day="'+Day+'" ', function (error, results, fields) {
// 		if (error)
// 			res.send(JSON.stringify({"status": 500, "error" : error}));
// 		if (results.length > 0)
// 			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
// 		else
// 			res.send(JSON.stringify({"status": 204, "success": false, "error": null, "response": "empty result"}));
// 	});    
// });


router.post('/', function(req, res) {

	var SupplyDate = req.body.SupplyDate;

	req.con.query('SELECT P.PowerSource ,ROUND(SUM(PR.Supply), 2) as total FROM powerplant P,powerplantsupplyrec PR WHERE PR.SupplyDate="'+SupplyDate+'" AND P.ID=PR.PowerPlants GROUP BY  P.PowerSource ' , function (error, results, fields) {
		if (error)
			res.send(JSON.stringify({"status": 500, "error" : error}));
		if (results.length > 0)
			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
		else
			res.send(JSON.stringify({"status": 204, "success": false, "error": null, "response": "empty result"}));
	});    
});

module.exports = router;
