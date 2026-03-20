export class UserSQLConstants {
  static createUserStoreSQL(tableName: string) {
    return `CREATE TABLE IF NOT EXISTS ${tableName} (
    USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ACCOUNT TEXT NOT NULL UNIQUE,
    USERNAME TEXT NOT NULL,
    AVATAR TEXT,
    SIGNATURE TEXT);`
  }

  static deleteUserTableSQL(tableName: string) {
    return `DROP TABLE IF EXISTS ${tableName};`
  }
}