function getEnv (name) {
  return process.env[name] || ''
}

// Check system required env variables
function checkRequiredVariables () {
  const envArray = [
    'CERT_PROVIDER_PORT',
    'FABRIC_CA_SERVER_TLS_CERTFILE',
    'FABRIC_CA_SERVER_DB_PATH',
    'ORG_NAME'
  ]

  envArray.forEach(element => {
    if (!process.env[element]) {
      throw new Error(`${element} is required`)
    }
  })
}

module.exports = {
  get: getEnv,
  check: checkRequiredVariables
}
