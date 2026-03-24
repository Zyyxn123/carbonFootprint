export class TendencySQL {
  static createTasksSQL(tableName: string) {
    return `CREATE TABLE IF NOT EXISTS ${tableName} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account TEXT NOT NULL,
    recordDate TEXT NOT NULL UNIQUE,
    tasksMsg TEXT,
    UNIQUE(account, recordDate));`
  }

  static deleteTasksTableSQL(tableName: string) {
    return `DROP TABLE IF EXISTS ${tableName};`
  }
}