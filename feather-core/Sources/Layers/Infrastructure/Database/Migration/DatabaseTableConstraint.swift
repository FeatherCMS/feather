public enum DatabaseTableConstraint: Sendable {
    case primaryKey([any DatabaseFieldRepresentable])
    case unique([any DatabaseFieldRepresentable])
    case foreignKey(
        columns: [any DatabaseFieldRepresentable],
        referencesTable: String,
        referencedColumns: [any DatabaseFieldRepresentable],
        onDelete: DatabaseReferentialAction?,
        onUpdate: DatabaseReferentialAction?
    )
}
