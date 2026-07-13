import FeatherDatabase
import Infrastructure

/// Allows form fields to share a priority, matching the ordering behavior used by menu items.
public struct ContactFormItemPositionConstraintMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(on connection: any DatabaseConnection) async throws {
        try await connection.run(
            query: #"ALTER TABLE contact_form_items DROP CONSTRAINT IF EXISTS contact_form_items_form_id_position_key;"#
        ) { _ in }
    }
}
