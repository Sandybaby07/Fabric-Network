const express = require('express')
const router = express.Router()

const controller = require('../controllers/cert.controller')

router.get('/ca', controller.getCACert)
router.get('/admin', controller.getAdminCert)

module.exports = router
