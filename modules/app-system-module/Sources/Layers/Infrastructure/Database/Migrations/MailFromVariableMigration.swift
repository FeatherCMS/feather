public import FeatherContracts
public import FeatherDatabase
public import FeatherDomain
public import FeatherInfrastructure
import SystemApplication
import SystemDomain

public struct MailFromVariableMigration: DatabaseMigration {
    private enum MigrationError: Swift.Error {
        case mailFromAddressProviderNotRegistered
        case multipleMailFromAddressProvidersRegistered
    }

    public let connection: any DatabaseConnection
    private let events: any EventPublisher
    private let idGenerator: any IDGenerator

    public init(
        connection: any DatabaseConnection,
        events: any EventPublisher,
        idGenerator: any IDGenerator
    ) {
        self.connection = connection
        self.events = events
        self.idGenerator = idGenerator
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let providers = try await events.trigger(
            event: MailFromAddressProvider(),
            using: EventContext()
        )
        guard let mailFromAddress = providers.first else {
            throw MigrationError.mailFromAddressProviderNotRegistered
        }
        guard providers.count == 1 else {
            throw MigrationError.multipleMailFromAddressProvidersRegistered
        }

        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: idGenerator
        )
        let repository = VariableDatabaseRepository(context: context)
        let mailFromAddressKey = "system-settings-mail-from-address"
        if var variable = try await repository.find(key: mailFromAddressKey) {
            if variable.value.isEmpty, !mailFromAddress.email.isEmpty {
                try variable.update(value: mailFromAddress.email)
                _ = try await repository.update(variable)
            }
        }
        else {
            _ = try await repository.insert(
                Variable.create(
                    key: mailFromAddressKey,
                    value: mailFromAddress.email,
                    name: "System mail from address",
                    notes:
                        "Sender address for system-generated emails."
                )
            )
        }

        let mailFromNameKey = "system-settings-mail-from-name"
        if var variable = try await repository.find(key: mailFromNameKey) {
            if variable.value.isEmpty,
                let name = mailFromAddress.name,
                !name.isEmpty
            {
                try variable.update(value: name)
                _ = try await repository.update(variable)
            }
        }
        else {
            _ = try await repository.insert(
                Variable.create(
                    key: mailFromNameKey,
                    value: mailFromAddress.name ?? "",
                    name: "System mail from name",
                    notes:
                        "Optional sender display name for system-generated emails."
                )
            )
        }
    }
}
