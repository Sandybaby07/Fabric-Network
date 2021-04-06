const db = require('../db/sql')

async function getCert (id) {
  try {
    const result = db.get('SELECT pem FROM certificates WHERE id = ?', [id])
    return result
  } catch (err) {
    return err
  }
}

module.exports = { getCert }
