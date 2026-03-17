export class UserSQLConstants {
  static readonly hasAcc: string = `SELECT 1 FROM USER_PROFILE WHERE ACCOUNT = ? LIMIT 1;`

  static createUserStoreSQL(name: string) {
    return `CREATE TABLE IF NOT EXISTS ${name} (
    USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ACCOUNT TEXT NOT NULL UNIQUE,
    USERNAME TEXT NOT NULL,
    AVATAR TEXT,
    SIGNATURE TEXT);`
  }

  static deleteUserTableSql(name: string) {
    return `DROP TABLE IF EXISTS ${name};`
  }
}