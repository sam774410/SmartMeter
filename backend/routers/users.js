var express = require('express');
var router = express.Router();
var nodemailer = require('nodemailer');
require('dotenv').config();

var transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        user: process.env.GMAIL_ACCT,
        pass: process.env.GMAIL_PWD
    }
});

//query all
router.get('/', function(req, res) {

	req.con.query('SELECT * from user', function (error, results, fields) {
		if (error)
			res.send(JSON.stringify({"status": 500, "error" : error}));
		if (results.length > 0)
			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
		else
			res.send(JSON.stringify({"status": 204, "success": false, "error": null, "response": "empty result"}));
	});
});

//insert a user
router.post('/', function(req, res){

	console.log('user register:');
	console.log(req.body);

	var Account = req.body.Account;
	var Password = req.body.Password;
	var EmailAddress = req.body.EmailAddress;
	var ContactPhoneNum = req.body.ContactPhoneNum;
	var ContactAddress = req.body.ContactAddress;
	var FirstName = req.body.FirstName;
	var LastName = req.body.LastName;
	var IdentityNum = req.body.IdentityNum;

	req.con.query("INSERT INTO user (Account, Password, EmailAddress, ContactPhoneNum, ContactAddress, FirstName, LastName, IdentityNum, Role) VALUES ('"+ Account +"', '"+ Password +"', '"+ EmailAddress +"', '"+ ContactPhoneNum +"', '"+ ContactAddress +"', '"+ FirstName +"', '"+ LastName +"', '"+ IdentityNum +"', '1') ", function(error, results, fields){
		if (error)
			res.send(JSON.stringify({"status": 500, "error" : error}));
		else
			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
		});
});

//query a user
router.post('/id', function(req, res){

	console.log('query a user:');
	console.log(req.body);

	var Account = req.body.Account;

	req.con.query("SELECT * FROM user WHERE Account = '" +Account+ "' ", function(error, results, fields){
			if (error)
				res.send(JSON.stringify({"status": 500, "error" : error}));
			if (results.length > 0)
				res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
			else
				res.send(JSON.stringify({"status": 204, "success": false, "error": null, "response": "empty result"}));
		});
});

//user login
router.post('/auth/id', function(req, res){

	console.log('user login:');
	console.log(req.body);

	var Account = req.body.Account;
	var Password = req.body.Password;

	req.con.query("SELECT * FROM user WHERE Account = '" +Account+ "' && Password = '"+ Password+"' ", function(error, results, fields){
			if (error)
				res.send(JSON.stringify({"status": 500, "error" : error}));
			if (results.length > 0)
				res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
			else
				res.send(JSON.stringify({"status": 204, "success": false, "error": null, "response": "empty result"}));
		});
});

//update a user
router.put('/id', function(req, res){
	
	console.log('update user info');
	console.log(req.body);

	var Account = req.body.Account;
	var EmailAddress = req.body.EmailAddress;
	var ContactPhoneNum = req.body.ContactPhoneNum;
	var ContactAddress = req.body.ContactAddress;
	var FirstName = req.body.FirstName;
	var LastName = req.body.LastName;


	req.con.query("UPDATE user SET FirstName = '"+FirstName+"', LastName = '"+LastName+"', EmailAddress = '"+EmailAddress+"', ContactPhoneNum = '"+ContactPhoneNum+"', ContactAddress = '"+ContactAddress+"' WHERE Account = '"+Account+"' ", function(error, results, fields){
		if (error)
			res.send(JSON.stringify({"status": 500, "error" : error}));
		else
			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
		});
});

//update a user pwd
router.put('/id/pwd', function(req, res){
	
	console.log('update user pwd');
	console.log(req.body);

	var Account = req.body.Account;
	var Password = req.body.Password;

	req.con.query("UPDATE user SET Password = '"+Password+"' WHERE Account = '"+Account+"' ", function(error, results, fields){
		if (error)
			res.send(JSON.stringify({"status": 500, "error" : error}));
		else
			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
		});
});

//send pwd mail 
router.post('/forget/pwd', function(req, res){
	
	console.log('ready to send password...');
	console.log(req.body);

	var Account = req.body.Account;
	var Password = req.body.Password;
	var EmailAddress = req.body.EmailAddress;

	options.subject = 'Forgot your login password?';
	options.to = EmailAddress
	options.text = 'Hi! '+ Account + '  Your password is: ' + Password + '\n  Please Note: This message is automatically sent, please do not reply directly!'; 

	transporter.sendMail(options, function(error, info){
		if(error){

			console.log(error);
			res.send(JSON.stringify({"status": 500, "error" : error}));
		}else{
			
			console.log('訊息發送: ' + info.response);
			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": '訊息發送: ' + info.response}));
		}
	});
	
});



var options = {
    //寄件者
    from: 'wenhechang1114@gmail.com',
    //收件者
    to: 'sam850118sam@gmail.com', 
    //副本
    //cc: 'account3@gmail.com',
    //密件副本
    //bcc: 'account4@gmail.com',
    //主旨
    subject: '這是 node.js 發送的測試信件', // Subject line
    //純文字
    text: 'Hello world2', // plaintext body
    //嵌入 html 的內文
    //html: '<h3> </h3> <p>The <a href="http://en.wikipedia.org/wiki/Lorem_ipsum" title="Lorem ipsum - Wikipedia, the free encyclopedia">Lorem ipsum</a> text is typically composed of pseudo-Latin words. It is commonly used as placeholder text to examine or demonstrate the visual effects of various graphic design. Since the text itself is meaningless, the viewers are therefore able to focus on the overall layout without being attracted to the text.</p>', 
    //附件檔案
    // attachments: [ {
    //     filename: 'text01.txt',
    //     content: '聯候家上去工的調她者壓工，我笑它外有現，血有到同，民由快的重觀在保導然安作但。護見中城備長結現給都看面家銷先然非會生東一無中；內他的下來最書的從人聲觀說的用去生我，生節他活古視心放十壓心急我我們朋吃，毒素一要溫市歷很爾的房用聽調就層樹院少了紀苦客查標地主務所轉，職計急印形。團著先參那害沒造下至算活現興質美是為使！色社影；得良灣......克卻人過朋天點招？不族落過空出著樣家男，去細大如心發有出離問歡馬找事'
    // }, {
    //     filename: 'unnamed.jpg',
    //     path: '/Users/Weiju/Pictures/unnamed.jpg'
    // }]
};


//query user meter
router.post('/retrieveMeter', function(req, res) {

	console.log("Query user meter");
	console.log(req);
	var UserID = req.body.UserID;
   
	req.con.query("SELECT * FROM meter WHERE UserID = " +UserID+ " ", function(error, results, fields){
		   if (error)
			   res.send(JSON.stringify({"status": 500, "error" : error}));
		   if (results.length > 0)
			   res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
		   else //目前沒有電表，提醒使用者加電表
			   res.send(JSON.stringify({"status": 204, "success": false, "error": null, "response": "empty result"}));
	  });
});

module.exports = router;
