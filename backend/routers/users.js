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
			if (results.length > 0){

				res.setHeader('Access-Control-Allow-Origin', '*');
				res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
				res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
			}
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




//update a meter
router.put('/update_meter', function(req, res){

	console.log('user add meter');
	console.log(req.body);

	var UserID = req.body.UserID;   //接收前端user_id
	var ID = req.body.ID;    //接收前端meter_id
	var myDate = new Date();  //取出日期時間
	myDate=myDate.toLocaleDateString();  //將日期取到日就好
	var ChargeType = req.body.ChargeType;   //接ChargeType 用來輸入在Comtract中 
   
	//先檢查該meter 是否有使用者
	req.con.query("SELECT Status FROM meter WHERE ID = '"+ID+"' ", function(error, results, fields){
	 //該電表不存在
		if (error){

			res.send(JSON.stringify({"status": 500, "error" : error}));
			res.end();
			return;
		}
	  		
	 	//電表存在 接著比對是否有人使用 
	 	else{  
			//  試著印出 status值 console.log(results[0]["Status"]);
	
			//meter的Status==-2 表示該電表尚未遭到綁定 所以可以進行綁定動作
			if(results[0]["Status"] == -2){    
				//這邊的UserID指的是meter裡面的UseID  , 而ID指的是 meter的ID  所以比對前端meter的ID後 , 將UserID資訊update
				req.con.query("UPDATE meter SET UserID = '"+UserID+"' ,Status = 1 WHERE ID = '"+ID+"' ", function(error, results, fields){
					if (error){

						res.send(JSON.stringify({"status": 500, "error" : error}));
						res.end();
						return;
					}
					else{

						res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results }));
						res.end();
						return;
					}
						
				});	
			}
			//meter的Status!=-2  表示該電表已經被綁定 所以不可以再綁定
			else{     
					res.send(JSON.stringify({"status": 403, "error" : '此電表已遭綁定，不可再綁定'})); 
					res.end();
					return;
			} 
	 	}
	});
	   
});





///add contract
router.put('/add_contract', function(req, res){

	console.log('add contract');
	console.log(req.body);
	var UserID = req.body.UserID;   //接收前端user_id
	var ID = req.body.ID;    //接收前端meter_id
	var myDate = new Date();  //取出日期時間
	myDate=myDate.toLocaleDateString();  //將日期取到日就好
	var ChargeType = req.body.ChargeType;   //接ChargeType 用來輸入在Comtract中 
   
	req.con.query("INSERT INTO contract (UserID, MeterID, StartDate,ChargeType) VALUES ('"+UserID +"', '"+ID+"', '"+myDate+"','"+ChargeType+"' ) ", function(error, results, fields){

		if (error)

		 	res.send(JSON.stringify({"status": 500, "error" : error}));
		else

		 	res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
	});  
});


// 傳送一筆暫停電表用電申請
router.post('/stop_meter', function(req, res) {

	console.log('user stop meter');
	console.log(req.body);

	var meterID = req.body.meterID;
	var StartDate = req.body.StartDate;
	var myDate = new Date();  //取出日期時間
	myDate=myDate.toLocaleDateString();  //將日期取到日就好
	
	//直接輸入 尚未檢查他的ＳＴＡＴＵＳ
	req.con.query("UPDATE meter SET Status = 0 WHERE ID = '"+meterID+"' ", function(error, results, fields){
		if (error)

	  		res.send(JSON.stringify({"status": 500, "error" : error}));
	 	else{
   
			//開始新增一筆 Suspendapply的Tuple 
			req.con.query("INSERT  INTO suspendapply (ContractID, StartDate, ApplyDate, Status, Type) VALUES ((Select b.ID from meter a, contract b where a.Id = b.MeterID and b.MeterID = '"+meterID+"' and b.EndDate is null), '"+StartDate+"', '"+myDate+"', 0, 1)", function(error, results, fields){
			if (error)

				res.send(JSON.stringify({"status": 500, "error" : error}));
			else

				res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
			}); 
		}
	});
});


//post_suspendapply_status
router.post('/post_suspendapply_status', function(req, res) {
	//接收傳入的meterID 找出contract 再找出suspendapply的status
	var meterID = req.body.meterID;
   
	req.con.query("Select  c.Status, c.Type from meter a, contract b, suspendapply c where a.Id = b.MeterID and b.ID = c.ContractID and b.MeterID = '"+ meterID +"' and b.EndDate is null and c.Status != -1" , function (error, results, fields) {
		if (error)
	  		res.send(JSON.stringify({"status": 500, "error" : error}));
	 	else
	  		res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
	});    // 以上代碼錯誤可以再寫更多 debug時可以更輕鬆
});


// cancel stop meter
router.post('/cancel_stop_meter', function(req, res) {

	console.log('user cancel stop meter');
	console.log(req.body);

	var meterID = req.body.meterID;
	//var StartDate = req.body.StartDate;
	var myDate = new Date();  //取出日期時間
	myDate=myDate.toLocaleDateString();  //將日期取到日就好
	
	//meter status update to 1
	req.con.query("UPDATE meter SET Status = 1 WHERE ID = '"+meterID+"' ", function(error, results, fields){
		if (error)

	  		res.send(JSON.stringify({"status": 500, "error" : error}));
	 	else{
   
			//update suspendapply table status = -1  where status = 0
			req.con.query("UPDATE suspendapply SET Status = -1, CancelDate = '"+ myDate +"' WHERE ContractID = (Select b.ID from meter a, contract b where a.Id = b.MeterID and b.MeterID = '"+ meterID+"' and b.EndDate is null) AND Status = 0 AND Type = 1", function(error, results, fields){
			if (error)

				res.send(JSON.stringify({"status": 500, "error" : error}));
			else

				res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
			}); 
		}
	});
});

// cancel stop meter
router.post('/cancel_recovery_meter', function(req, res) {

	console.log('user recovery meter');
	console.log(req.body);

	var meterID = req.body.meterID;
	//var StartDate = req.body.StartDate;
	var myDate = new Date();  //取出日期時間
	myDate=myDate.toLocaleDateString();  //將日期取到日就好
	
	//meter status update to 1
	req.con.query("UPDATE meter SET Status = -1 WHERE ID = '"+meterID+"' ", function(error, results, fields){
		if (error)

	  		res.send(JSON.stringify({"status": 500, "error" : error}));
	 	else{
   
			//update suspendapply table status = -1  where status = 0
			req.con.query("UPDATE suspendapply SET Status = -1, CancelDate = '"+ myDate +"' WHERE ContractID = (Select b.ID from meter a, contract b where a.Id = b.MeterID and b.MeterID = '"+ meterID+"' and b.EndDate is null) AND Status = 0 AND Type = 2", function(error, results, fields){
			if (error)

				res.send(JSON.stringify({"status": 500, "error" : error}));
			else

				res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
			}); 
		}
	});
});

router.post('/abolish_meter', function(req, res) {

	console.log('user abolish meter');
	console.log(req.body);

	var meterID = req.body.meterID;
	var userID = req.body.userID;

	var myDate = new Date();  //取出日期時間
	myDate=myDate.toLocaleDateString();  //將日期取到日就好
	
	//meter status update to 1
	req.con.query("UPDATE contract SET EndDate = '"+ myDate +"' WHERE UserID = '"+ userID +"' AND MeterID = '"+ meterID +"' AND EndDate is null ", function(error, results, fields){
		if (error)

	  		res.send(JSON.stringify({"status": 500, "error" : error}));
	 	else{
   
			//update suspendapply table status = -1  where status = 0
			req.con.query("UPDATE meter SET Status = -2, UserID = null WHERE UserID = '"+ userID +"' AND ID = '"+ meterID +"' ", function(error, results, fields){
			if (error)

				res.send(JSON.stringify({"status": 500, "error" : error}));
			else

				res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
			}); 
		}
	});
});

//復電申請
router.post('/recovery_meter', function(req, res) {

	console.log('user recovery meter');
	console.log(req.body);

	var meterID = req.body.meterID;
	var userID = req.body.userID;
	var StartDate = req.body.StartDate;

	var myDate = new Date();  //取出日期時間
	myDate=myDate.toLocaleDateString();  //將日期取到日就好
	
	//meter status update to 0
	req.con.query("UPDATE meter SET Status = 0 WHERE UserID = '"+ userID +"' AND ID = '"+ meterID +"' ", function(error, results, fields){
		if (error)

	  		res.send(JSON.stringify({"status": 500, "error" : error}));
	 	else{
   
			req.con.query("INSERT  INTO suspendapply (ContractID, StartDate, ApplyDate, Status, Type) VALUES ((Select b.ID from meter a, contract b where a.Id = b.MeterID and b.MeterID = '"+meterID+"' AND b.EndDate is null), '"+StartDate+"', '"+myDate+"', 0, 2)", function(error, results, fields){
			if (error)

				res.send(JSON.stringify({"status": 500, "error" : error}));
			else

				res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
			}); 
		}
	});
});

//get_more_information (傳入meter)
router.get('/get_more_information', function(req, res) {

	var meterID = req.body.meterID; 
	req.con.query('SELECT C.ID ,U.FirstName ,U.LastName ,M.Address ,U.ContactAddress ,S.ApplyDate ,S.StartDate ,S.Status ,U.ContactAddress ,S.EndDate FROM suspendapply S,contract C,user U,meter M WHERE S.ContractID = C.ID AND M.ID="'+meterID+'" AND C.MeterID=M.ID AND U.ID=M.UserID ', function (error, results, fields) {
	 	if (error)
	  		res.send(JSON.stringify({"status": 500, "error" : error}));
	 	if (results.length > 0)
	  		res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
	 	else
	  		res.send(JSON.stringify({"status": 204, "success": false, "error": null, "response": "empty result"}));
	});    // 以上代碼錯誤可以再寫更多 debug時可以更輕鬆
});

//query suspendapply info
//管理者 req 是使用者發送要求，而res為回覆，參數後可直接改成要回覆的東西 
router.get('/suspendapply', function(req, res) {

	req.con.query('SELECT S.ID,LastName,FirstName,ContractID,M.Address,S.Status,S.ApplyDate FROM suspendapply S,contract C,user U,meter M WHERE S.ContractID = C.ID AND C.UserID = U.ID AND M.ID=C.MeterID ', function (error, results, fields) {
		if (error)
			res.send(JSON.stringify({"status": 500, "error" : error}));
		if (results.length > 0)
			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
		else
			res.send(JSON.stringify({"status": 204, "success": false, "error": null, "response": "empty result"}));
	});    // 以上代碼錯誤可以再寫更多 debug時可以更輕鬆
});

router.post('/month_fee', function(req, res) {
	//下面這串不用理會  單純原本用下ＳＱＬ想找出 電表跟費用
	//SELECT MonthFee FROM monthfee M,contract C WHERE  Year='"+Year+"' AND Month='"+Month+"' AND C.UserID='"+userID+"' AND C.ID=M.ContractID
	//var Year = feeDate.getFullYear();
	//var Month = feeDate.getMonth();

	var userID = req.body.userID;
	var feeDate = new Date();		//取出日期時間
	feeDate=feeDate.toLocaleDateString();		//將日期取到日就好

	req.con.query("call MonthFee_Select('"+userID+"','"+feeDate+"')" , function (error, results, fields) {
		if (error)
			res.send(JSON.stringify({"status": 500, "error" : error}));
		else 
			res.send(JSON.stringify({"status": 200, "success": true, "error": null, "response": results}));
			
	});    // 以上代碼錯誤可以再寫更多 debug時可以更輕鬆 
});

module.exports = router;
