const express = require('express')
const morgan = require('morgan')
const cors = require('cors')

// Routes
const indexRoutes = require('./routes/index.routes')
const certRoutes = require('./routes/cert.routes')

const app = express()

// Allow CORS
app.options('*', cors())
app.use(cors())

app.use(morgan('combined'))

// Routes
app.use('/', indexRoutes)
app.use('/cert', certRoutes)

module.exports = app
