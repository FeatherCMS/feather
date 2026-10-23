import ContactDomain
import ContactModule
import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure

public struct TableSeedMigration: DatabaseMigration {
    public let context: DatabaseTransactionContext

    public var connection: any DatabaseConnection {
        context.connection
    }

    public init(
        context: DatabaseTransactionContext
    ) {
        self.context = context
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let repository = FormField.Repository.Database(
            context: context
        )
        let existingKeys = Set(
            try await repository.listBy(formId: nil).map(\.key)
        )

        let fields = [
            try FormField.Model.create(
                formId: "",
                key: "email",
                type: .text,
                label: "Email",
                isRequired: true
            ),
            try FormField.Model.create(
                formId: "",
                key: "firstName",
                type: .text,
                label: "First name"
            ),
            try FormField.Model.create(
                formId: "",
                key: "lastName",
                type: .text,
                label: "Last name"
            ),
            try FormField.Model.create(
                formId: "",
                key: "message",
                type: .textarea,
                label: "Message"
            ),
        ]

        for field in fields where !existingKeys.contains(field.key) {
            _ = try await repository.insert(field)
        }
    }
}
