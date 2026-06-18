import Testing
import Logging
import Infrastructure
import FeatherDatabase
import FeatherDatabasePostgres
import Foundation
import NIOSSL
import PostgresNIO

import Domain
import Application
import RedirectDomain
import RedirectApplication

@testable import RedirectInfrastructure

@Suite
struct RedirectInfrastructureTestSuite {

    @Test
    func example() async throws {
        var logger = Logger(label: "test")
        logger.logLevel = .info

        var tlsConfiguration = TLSConfiguration.makeClientConfiguration()
        tlsConfiguration.certificateVerification = .none

        let client = PostgresClient(
            configuration: .init(
                host: ProcessInfo.processInfo.environment["POSTGRES_HOST"]
                    ?? "127.0.0.1",
                port: Int(
                    ProcessInfo.processInfo.environment["POSTGRES_PORT"]
                        ?? "55432"
                ) ?? 55432,
                username: ProcessInfo.processInfo.environment["POSTGRES_USER"]
                    ?? "postgres",
                password: ProcessInfo.processInfo.environment[
                    "POSTGRES_PASSWORD"
                ] ?? "postgres",
                database: ProcessInfo.processInfo.environment["POSTGRES_DB"]
                    ?? "postgres",
                tls: .require(tlsConfiguration)
            ),
            backgroundLogger: logger
        )

        let database = DatabaseClientPostgres(
            client: client,
            logger: logger
        )
        let clientTask = Task {
            await client.run()
        }
        defer { clientTask.cancel() }
        try await Task.sleep(for: .milliseconds(25))

        try await database.withTransaction { connection in
            try await connection.run(
                query: #"""
                    DROP SCHEMA IF EXISTS public CASCADE;
                    """#
            ) { _ in }
            try await connection.run(
                query: #"""
                    CREATE SCHEMA public;
                    """#
            ) { _ in }

            let migrator = Migrator(
                migrations: [
                    TableMigration(connection: connection),
                    TableSeedMigration(connection: connection),
                ],
                logger: logger
            )

            try await migrator.apply(on: connection)

        }

        let idGenerator = Foo()
        let authorizer = AllowAllAuthorizer()

        let transaction = DatabaseTransactionExecutor(database: database) {
            WriteRule(
                rule: DatabaseRuleRepository(connection: $0)
            )
        }

        let useCase = AddRule(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: idGenerator
        )

        let res = try await useCase.execute(
            subject: .init(id: "infra-test"),
            input: .init(
                source: "/foo-bar",
                destination: "/bar-bar",
                statusCode: 301,
                notes: "baz-bar"
            )
        )
        #expect(res.source == "/foo-bar")

        let query = DatabaseQueryExecutor(database: database) {
            GenericScope(
                [
                    "rule": DatabaseRuleRepository(connection: $0)
                ]
            )
            //            RuleContext(
            //                rule: DatabaseRuleRepository(connection: $0)
            //            )
        }

        let rule = try await query.run { ctx in
            ctx.rule
        }
        print(rule)

        let useCase2 = AddRule(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: idGenerator
        )

        _ = useCase2
    }
}

@dynamicMemberLookup
struct GenericScope<T: Sendable>: Scope {
    private var storage: [String: T]

    init(
        _ storage: [String: T]
    ) {
        self.storage = storage
    }

    subscript(dynamicMember key: String) -> T {
        storage[key]!
    }
}

struct Foo: IDGenerator {
    func generate() -> String {
        "foo"
    }
}

struct AllowAllAuthorizer: Authorizer {
    func can(
        subject: Subject,
        perform action: any Action
    ) async throws -> Bool {
        true
    }
}
