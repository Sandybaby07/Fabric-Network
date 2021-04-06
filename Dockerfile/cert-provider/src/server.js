const app = require('./app')
const envHelper = require('./helpers/envHelper')

// Logger
const LogService = require('./service/LogService')
const logger = new LogService('server')

const port = envHelper.get('CERT_PROVIDER_PORT')

Promise.all([
  envHelper.check()
]).then(() => {
  app.listen(port, () => {
    logger.info('cert-provider service started')
  })
}).catch(err => {
  logger.error(err.message)
})
