const express = require('express')
const models = require('./models')
const app = express()

// JSON parser
app.use(express.json())// this is a middleware so the request will be parsed as JSON

app.post('/register', (req, res) => {

    const {username, password} = req.body
    
    //create a new user

    const newUser = models.User.create({
        username: username,
        password: password
    })

    //validate the request
    if use
    res.status(201).json({ success: true})
    





})

//start the server
app.listen(8080, () => {
    console.log('Server is running at http://localhost:8080 ')
})