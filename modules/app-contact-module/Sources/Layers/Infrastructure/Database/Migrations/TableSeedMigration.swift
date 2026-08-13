import ContactDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

public struct TableSeedMigration: DatabaseMigration {
    public let connection: any DatabaseConnection
    private let idGenerator: any IDGenerator

    public init(
        connection: any DatabaseConnection,
        idGenerator: any IDGenerator
    ) {
        self.connection = connection
        self.idGenerator = idGenerator
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: idGenerator
        )
        let repository = FormFieldDatabaseRepository(
            context: context
        )
        let existingKeys = Set(
            try await repository.listBy(formId: nil).map(\.key)
        )

        let fields:
            [(
                key: String,
                type: FormField.ItemType,
                label: String,
                isRequired: Bool
            )] = [
                ("email", .text, "Email", true),
                ("firstName", .text, "First name", false),
                ("lastName", .text, "Last name", false),
                ("message", .textarea, "Message", false),
            ]

        for field in fields where !existingKeys.contains(field.key) {
            _ = try await repository.insert(
                FormField.create(
                    formId: "",
                    key: field.key,
                    type: field.type,
                    label: field.label,
                    isRequired: field.isRequired
                )
            )
        }
    }
}
