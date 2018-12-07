var express = require('express');
var mysql = require('mysql');
var bodyParser = require('body-parser');
require('dotenv').config();

var countys = require('./routers/countys');
var users = require('./routers/users');

var app = express();

//body解析
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:false}));


//Database connection
var con = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PWD,
    database: process.env.DB_NAME
});

con.connect(function(err) {
    if (err) {
        console.log('connecting error');
        return;
    }
    console.log('connecting success');
});

// db state
app.use(function(req, res, next) {
    req.con = con;
    next();
});

// app.use('/api/v1/users', users);

app.get('/', function(req, res, next) {
	res.send('Hello');
});

app.use('/users',users);
app.use('/countys',countys);



app.use(function(req, res, next){
    res.status(404).send('很抱歉，您的頁面找不到');
});

app.use(function(err, req, res, next){
    console.error(err.stack);
    res.status(500).send('請稍後再試');
});

var port = process.env.port || 2000;
app.listen(port);