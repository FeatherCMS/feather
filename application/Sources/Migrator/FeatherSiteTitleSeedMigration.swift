import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemDomain
import SystemInfrastructure
import SystemModule

struct FeatherSiteTitleSeedMigration: DatabaseMigration {
    let context: DatabaseTransactionContext

    var connection: any DatabaseConnection {
        context.connection
    }

    func apply(on connection: any DatabaseConnection) async throws {
        let transactionContext = DatabaseTransactionContext(
            platform: context.platform,
            connection: connection,
            idGenerator: context.idGenerator
        )
        let repository = Variable.Repository.Database(
            context: transactionContext
        )

        if var variable = try await repository.find(key: "web-settings-title")
        {
            guard variable.value.isEmpty else { return }
            try variable.update(
                name: .set("Website title"),
                value: .set("Feather CMS"),
                notes: .set("Title of the website")
            )
            _ = try await repository.update(variable)
        }
        else {
            _ = try await repository.insert(
                Variable.Model.create(
                    key: "web-settings-title",
                    value: "Feather CMS",
                    name: "Website title",
                    notes: "Title of the website"
                )
            )
        }
    }
}
