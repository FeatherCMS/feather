public import FeatherContracts
public import FeatherDatabase
public import FeatherDomain
public import FeatherInfrastructure
import SystemApplication
import SystemDomain

public struct MailFromVariableMigration: DatabaseMigration {
    public let connection: any DatabaseConnection
    private let idGenerator: any IDGenerator
    private let mailFromAddress: String

    public init(
        connection: any DatabaseConnection,
        idGenerator: any IDGenerator,
        mailFromAddress: String
    ) {
        self.connection = connection
        self.idGenerator = idGenerator
        self.mailFromAddress = mailFromAddress
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: idGenerator
        )
        let repository = VariableDatabaseRepository(context: context)
        let key = "system-settings-mail-from-address"

        if var variable = try await repository.find(key: key) {
            guard variable.value.isEmpty else {
                return
            }

            try variable.update(value: mailFromAddress)
            _ = try await repository.update(variable)
            return
        }

        _ = try await repository.insert(
            Variable.create(
                key: key,
                value: mailFromAddress,
                name: "System mail from address",
                notes:
                    "Required sender address for system-generated emails. Configure this value in System → Variables."
            )
        )
    }
}
