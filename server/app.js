const express = require('express')
const app = express()

const movies = [{title: 'Lordasdas dasd dad adas', genre: 'Fiction'}, {title: 'Lordasdas dasd dad adas', genre: 'action'}, {title: 'Lordasdas dasd dad adas', genre: 'Kids'}]

app.use(express.json())

app.get('/', (req, res) => {
    res.send('Hello Worlds')
})

app.get('/movies', (req, res) => {
    res.json(movies)
})
app.get('/about', (req, res) => {
    res.json({message: 'Hello World'})
})

app.get('/movies/:genre', (req, res) => {

    const genre = req.params.genre
    const filteredMovies = movies.filter(movies => movies.genre.toLowerCase() === genre.toLowerCase())
    res.json(filteredMovies)

    // res.send(`You selected ${genre} movies`)
})


app.get('/movies/:genre/year/:year', (req, res) => {

    const genre = req.params.genre
    const year = parseInt(req.params.year)

    res.send(`You selected ${genre} movies and the year is ${year}`)
})

app.post('/movies', (req, res) => {
    console.log(req.body)
    const {title, genre} = req.body
    res.send('OK')
})

//start the server
app.listen(8080, () => {
    console.log('Server is running at http://localhost:8080 ')
})