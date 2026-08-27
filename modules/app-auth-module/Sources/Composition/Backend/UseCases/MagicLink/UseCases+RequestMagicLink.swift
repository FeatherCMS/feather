import AuthAdminAPI
import AuthAppAPI
import AuthApplication
import AuthInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import UserApplication
import UserBackend
import UserInfrastructure

extension UseCases {

    func makeRequestMagicLink() -> RequestMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteAuth(
                    identity: IdentityDatabaseRepository(context: context),
                    credential: CredentialDatabaseRepository(context: context),
                    session: SessionDatabaseRepository(context: context),
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        let variable = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadVariable(
                    variable: VariableDatabaseQueries(context: context)
                )
            }
        )
        return RequestMagicLink(
            transaction: transaction,
            mailSender: mailSender,
            publicBaseURL: publicBaseURL,
            variable: VariableDatabaseQueryExecutor(executor: variable)
        )
    }
}

private struct VariableDatabaseQueryExecutor: VariableQueries {

    let query: DatabaseQueryExecutor<ReadVariable>

    init(
        executor: DatabaseQueryExecutor<ReadVariable>
    ) {
        self.query = executor
    }

    func get(
        _ id: String
    ) async throws -> String? {
        try await query.run { scope in
            try await scope.variable.get(id)
        }
    }

    func find(
        id: String
    ) async throws -> VariableDetail {
        try await query.run { scope in
            try await scope.variable.find(id: id)
        }
    }

    func list(
        query: VariableList.Query
    ) async throws -> VariableList {
        try await self.query.run { scope in
            try await scope.variable.list(query: query)
        }
    }

    func count(
        query: VariableList.Query
    ) async throws -> Int {
        try await self.query.run { scope in
            try await scope.variable.count(query: query)
        }
    }
}
