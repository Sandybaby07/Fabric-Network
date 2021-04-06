const fs = require('fs')
const envHelper = require('../helpers/envHelper')

const certHelper = require('../helpers/certHelper')

module.exports = {
  getCACert (req, res) {
    try {
      const caCert = fs.readFileSync(envHelper.get('FABRIC_CA_SERVER_TLS_CERTFILE'))
      res.send(caCert)
    } catch (err) {
      res.send(err.message)
    }
  },
  async getAdminCert (req, res) {
    const orgName = envHelper.get('ORG_NAME')
    const adminID = 'Admin.' + orgName + '.com'
    try {
      const adminCert = await certHelper.getCert(adminID)
      res.send(adminCert)
    } catch (err) {
      res.send(err.message)
    }
  }
}
