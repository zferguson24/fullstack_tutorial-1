const express = require("express");
const mysql = require("mysql");
const ejs = require("ejs");

// Create express app
const app = express();

// Create a database connection configuration
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "root123",
  database: "mydb",
});

// Establish connection with the DB
db.connect((err) => {
  if (err) {
    throw err;
  } else {
    console.log(`Successful connected to the DB....`);
  }
});

// Initialize Body Parser Middleware to parse data sent by users in the request object
app.use(express.json());
app.use(express.urlencoded({ extended: true })); // to parse HTML form data

// Initialize ejs Middleware
app.set("view engine", "ejs");
app.use("/public", express.static(__dirname + "/public"));

// routes
app.get("/", (req, res) => {
  res.render("index");
});


// Add eBook Logic
app.get("/addebook", (req, res) => {
    res.render("addeBook");
});

app.post("/insertebook", (req, res) => {
  let data = {EBOOK_TITLE: req.body.eBookTitle, EBOOK_ISBN: req.body.eBookISBN, EBOOK_AUTHOR: req.body.eBookAuthor,
    EBOOK_GENRE: req.body.eBookGenre, EBOOK_PRICE: req.body.eBookPrice, EBOOK_DESC: req.body.eBookDesc, 
    EBOOK_PUB: req.body.eBookPub};
  let sql = `INSERT INTO EBOOK SET ?`;
  let query = db.query(sql, data, (err, result) => {
    if (err) {
      throw err;
    }
    res.send(`eBook successfully inserted into the database.`);
  });
});

// Create Account Logic
app.get("/signup", (req, res) => {
  res.render("signup");
});

app.post("/insertuser", (req, res) => {
  let sql = `INSERT INTO USER SET USER_EMAIL = '${req.body.userEmail}', USER_PASSWORD = sha1('${req.body.userPassword}'), 
  USER_FNAME = '${req.body.userFname}', USER_LNAME = '${req.body.userLname}', USER_DOB = '${req.body.userDOB}',
  USER_DATEJOIN = now(), USER_ADMIN = 0;`;
  let query = db.query(sql, (err, result) => {
    if (err) {
      throw err;
    }
    res.send(`Account has been created successfully.`);
  });
});

// Search eBook Logic
app.post("/searchebook", (req, res) => {
  let sql = `SELECT * FROM EBOOK WHERE EBOOK_TITLE LIKE '%${req.body.eBookTitleSearch}%' `;

  // Add EBOOK_AUTHOR to query if nonempty.
  if (req.body.eBookAuthorCheck && req.body.eBookAuthorSearch != undefined) {
    sql = sql + `AND EBOOK_AUTHOR LIKE '%${req.body.eBookAuthorSearch}%' `;
  }
  // Add EBOOK_GENRE to query if nonempty.
  if (req.body.eBookGenreCheck && req.body.eBookGenreSearch != undefined) {
    sql = sql + `AND EBOOK_GENRE LIKE '%${req.body.eBookGenreSearch}%' `;
  }
  // Add EBOOK_PRICE to query if nonempty.
  if (req.body.eBookPriceCheck && req.body.eBookPriceSearch != undefined) {
    sql = sql + `AND EBOOK_PRICE LIKE '%${req.body.eBookPriceSearch}%' `;
  }
  // Add EBOOK_PUB to query if nonempty.
  if (req.body.eBookPublishDateCheck && req.body.eBookPublishDateSearch != undefined) {
    sql = sql + `AND EBOOK_PUB = '${req.body.eBookPublishDateSearch}' `;
  }

  // Order the final output by title of the returned eBooks.
  sql = sql + ` ORDER BY EBOOK_TITLE;`;

  db.query(sql, (err, result) => {
    if (err) {
      throw err;
    }
    res.render("searchResults", { data: result });
  });
});


// Search User Logic
app.get("/usersearch", (req, res) => {
  res.render("userSearch");
});

app.post("/searchuser", (req, res) => {
  let sql = `SELECT * FROM USER WHERE USER_EMAIL LIKE '%${req.body.userSearch}%';`;
  let query = db.query(sql, (err, result) => {
    if (err) {
      throw err;
    }
    res.render("readUser", { data: result });
  });
});

// Update User Logic
app.post("/updateuser", (req, res) => {
  let sql = `UPDATE USER SET `;

  // Update USER_EMAIL if nonempty.
  if (req.body.userEmail != undefined) {
    sql = sql + `USER_EMAIL = '${req.body.userEmail}', `;
  }
  // Update USER_FNAME if nonempty.
  if (req.body.userFname != undefined) {
    sql = sql + `USER_FNAME = '${req.body.userFname}', `;
  }
  // Update USER_LNAME if nonempty.
  if (req.body.userLname != undefined) {
    sql = sql + `USER_LNAME = '${req.body.userLname}', `;
  }
  // Update USER_DOB if nonempty.
  if (req.body.userDOB != undefined) {
    sql = sql + `USER_DOB = '${req.body.userDOB}' `;
  }

  // Deal with potentially having an extra, incorrect comma.
  if (sql.slice(-1) == `,`) {
    sql = sql.substring(0, sql.length - 1);
  }

  // Add WHERE clause to UPDATE to pick the correct user.
  sql = sql + ` WHERE USER_ID = '${req.body.userID}';`;

  let query = db.query(sql, (err, result) => {
    if (err) {
      throw err;
    }
    res.send(`User has been updated successfully.`);
  });
});

// Shows entire EBOOK table.
app.get("/readebook", (req, res) => {
  let sql = `SELECT * FROM EBOOK ORDER BY EBOOK_TITLE;`;
  db.query(sql, (err, result) => {
    if (err) {
      throw err;
    }
    res.render("readData", { data: result });
  });
});

// Setup server ports
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server is running on ${PORT}`));
