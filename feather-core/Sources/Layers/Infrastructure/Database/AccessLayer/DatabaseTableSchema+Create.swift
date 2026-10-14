import FeatherDatabase
import Foundation

public extension DatabaseTableSchema {

    func createTableQuery(
        ifNotExists: Bool = true
    ) -> DatabaseQuery {
        let existenceClause = ifNotExists ? "IF NOT EXISTS " : ""
        let columnDefinitions = columns.map { column in
            let type = switch column.type {
            case .text:
                "TEXT"
            case .integer:
                "INTEGER"
            case .timestampWithTimeZone:
                "TIMESTAMPTZ"
            }
            let columnConstraints = column.constraints.map { constraint in
                switch constraint {
                case .primaryKey:
                    "PRIMARY KEY"
                case .notNull:
                    "NOT NULL"
                case .unique:
                    "UNIQUE"
                case .defaultValue(let value):
                    columnDefaultSQL(value)
                }
            }
            let suffix = ([type] + columnConstraints).joined(separator: " ")
            return "\(quoteIdentifier(column.name)) \(suffix)"
        }
        let definitions = (
            columnDefinitions + constraints.map(createTableConstraintSQL)
        )
        .joined(separator: ",\n    ")

        return DatabaseQuery(
            unsafeSQL: """
                CREATE TABLE \(existenceClause)\(quoteIdentifier(name)) (
                    \(definitions)
                );
                """,
            bindings: []
        )
    }

    func createIndexQueries(
        ifNotExists: Bool = true
    ) -> [DatabaseQuery] {
        let existenceClause = ifNotExists ? "IF NOT EXISTS " : ""
        return indexes.map { index in
            let uniqueClause = index.isUnique ? "UNIQUE " : ""
            let columns = index.columns
                .map { quoteIdentifier($0.name) }
                .joined(separator: ", ")
            return DatabaseQuery(
                unsafeSQL: """
                    CREATE \(uniqueClause)INDEX \(existenceClause)\(quoteIdentifier(index.name))
                    ON \(quoteIdentifier(name)) (\(columns));
                    """,
                bindings: []
            )
        }
    }

    private func createTableConstraintSQL(
        _ constraint: DatabaseTableConstraint
    ) -> String {
        switch constraint {
        case .primaryKey(let columns):
            "PRIMARY KEY (\(columnNamesSQL(columns)))"
        case .unique(let columns):
            "UNIQUE (\(columnNamesSQL(columns)))"
        case .foreignKey(
            columns: let columns,
            referencesTable: let referencesTable,
            referencedColumns: let referencedColumns,
            onDelete: let onDelete,
            onUpdate: let onUpdate
        ):
            var sql = "FOREIGN KEY (\(columnNamesSQL(columns)))"
            sql += " REFERENCES \(quoteIdentifier(referencesTable))"
            sql += " (\(columnNamesSQL(referencedColumns)))"
            if let onDelete {
                sql += " ON DELETE \(referentialActionSQL(onDelete))"
            }
            if let onUpdate {
                sql += " ON UPDATE \(referentialActionSQL(onUpdate))"
            }
            return sql
        }
    }

    private func columnNamesSQL(
        _ columns: [any DatabaseFieldRepresentable]
    ) -> String {
        columns.map { quoteIdentifier($0.name) }.joined(separator: ", ")
    }

    private func referentialActionSQL(
        _ action: DatabaseReferentialAction
    ) -> String {
        switch action {
        case .noAction:
            "NO ACTION"
        case .restrict:
            "RESTRICT"
        case .cascade:
            "CASCADE"
        case .setNull:
            "SET NULL"
        case .setDefault:
            "SET DEFAULT"
        }
    }

    private func columnDefaultSQL(
        _ value: DatabaseColumnDefault
    ) -> String {
        switch value {
        case .currentTimestamp:
            "DEFAULT (NOW())"
        case .integer(let value):
            "DEFAULT \(value)"
        }
    }

    private func quoteIdentifier(_ identifier: String) -> String {
        "\"\(identifier.replacingOccurrences(of: "\"", with: "\"\""))\""
    }
}
