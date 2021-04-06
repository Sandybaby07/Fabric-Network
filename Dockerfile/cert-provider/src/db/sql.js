const sqlite = require('sqlite3')
const envHelper = require('../helpers/envHelper')

const dbPath = envHelper.get('FABRIC_CA_SERVER_DB_PATH')

const db = new sqlite.Database(dbPath)

async function get (sql, params) {
  return new Promise((resolve, reject) => {
    db.get(sql, params, (err, row) => {
      if (err) {
        reject(err)
      } else {
        if (row === undefined) {
          var result = 'no record'
        } else {
          result = row.pem
        }
        resolve(result)
      }
    })
  })
}

module.exports = { get }
