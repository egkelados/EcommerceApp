const express = require('express');
const models = require('./models');
const { body, validationResult } = require('express-validator');
const app = express()

// JSON parser
app.use(express.json())// this is a middleware so the request will be parsed as JSON

const registerValidator = [
    body('username', 'username cannot be emty!').not().isEmpty(),
    body('password', 'password cannot be emty!').not().isEmpty()
]

app.post('/register', registerValidator, (req, res) => {

    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        const mes = errors.array().map(e => e.msg).join(', ')
        return res.status(422).json({ success: false , errors: mes })
    }
    

    const {username, password} = req.body
    
    //create a new user

    const newUser = models.User.create({
        username: username,
        password: password
    })

    //validate the request



    res.status(201).json({ success: true})
    





})

//start the server
app.listen(8080, () => {
    console.log('Server is running at http://localhost:8080 ')
})