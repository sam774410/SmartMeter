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

//insert a student
router.post('/', function(req, res){

	
	var s_id = req.body.s_id;
	var s_name = req.body.s_name;
	var s_phone = req.body.s_phone;
	var s_note = req.body.s_note;

	req.con.query("INSERT INTO student (s_id, s_name, s_phone, s_note) VALUES ("+ s_id +", '"+ s_name +"', "+ s_phone +", '"+ s_note +"') ", function(error, results, fields){
		if (error)
			res.send(JSON.stringify({"status": 500, "error" : error}));
		else
			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
		});
});

//query a student
router.post('/ID', function(req, res){

	//console.log('query a student:'+req.body);
	var s_id = req.body.s_id;

	req.con.query("SELECT * FROM student WHERE s_id = '" +s_id+ "' ", function(error, results, fields){
			if (error)
				res.send(JSON.stringify({"status": 500, "error" : error}));
			if (results.length > 0)
				res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
			else
				res.send(JSON.stringify({"status": 204, "success": false, "error": null, "response": "empty result"}));
		});
});

//update a student
router.put('/ID', function(req, res){

	
	var s_id = req.body.s_id;
	var s_name = req.body.s_name;
	var s_phone = req.body.s_phone;
	var s_note = req.body.s_note;

	req.con.query("UPDATE student SET s_name = '"+s_name+"', s_phone = '"+s_phone+"', s_note = '"+s_note+"' WHERE s_id = '"+s_id+"' ", function(error, results, fields){
		if (error)
			res.send(JSON.stringify({"status": 500, "error" : error}));
		else
			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
		});
});

//delete a student (normal)
router.delete('/ID', function(req, res){

	var s_id = req.body.s_id;

	req.con.query("DELETE FROM student WHERE s_id = '" +s_id+ "' ", function(error, results, fields){
			if (error)
				res.send(JSON.stringify({"status": 500, "error" : error}));
			else
				res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));	
		});
});

//delete a student (ios)
router.post('/deleteID', function(req, res){

	var s_id = req.body.s_id;

	req.con.query("DELETE FROM student WHERE s_id = '" +s_id+ "' ", function(error, results, fields){
			if (error)
				res.send(JSON.stringify({"status": 500, "error" : error}));
			else
				res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));	
		});
});



module.exports = router;
