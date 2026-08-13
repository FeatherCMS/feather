//
//  RedirectInfrastructureTestSuite.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDatabasePostgres
import FeatherDomain
import FeatherInfrastructure
import Foundation
import Logging
import NIOSSL
import PostgresNIO
import RedirectApplication
import RedirectDomain
import Testing

@testable import RedirectInfrastructure

@Suite
struct RedirectInfrastructureTestSuite {

    @Test
    func example() async throws {
        var tlsConfiguration = TLSConfiguration.makeClientConfiguration()
        tlsConfiguration.certificateVerification = .none

        let client = PostgresClient(
            configuration: .init(
                host: ProcessInfo.processInfo.environment["POSTGRES_HOST"]
                    ?? "127.0.0.1",
                port: Int(
                    ProcessInfo.processInfo.environment["POSTGRES_PORT"]
                        ?? "55439"
                ) ?? 55439,
                username: ProcessInfo.processInfo.environment["POSTGRES_USER"]
                    ?? "postgres",
                password: ProcessInfo.processInfo.environment[
                    "POSTGRES_PASSWORD"
                ] ?? "postgres",
                database: ProcessInfo.processInfo.environment["POSTGRES_DB"]
                    ?? "postgres",
                tls: .require(tlsConfiguration)
            ),
            backgroundLogger: Logger.current
        )

        let database = DatabaseClientPostgres(
            client: client
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
                    TableMigration(connection: connection)
                ]
            )

            try await migrator.apply(on: connection)

        }

        let authorizer = AllowAllAuthorizer()

        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: Foo()
        ) { context in
            WriteRule(
                rule: RuleDatabaseRepository(
                    context: context
                )
            )
        }

        let useCase = AddRule(
            authorizer: authorizer,
            transaction: transaction
        )

        let res = try await useCase.execute(
            subject: .init(id: "infra-test"),
            input: .init(
                source: "/foo-bar",
                destination: "/bar-bar",
                statusCode: .movedPermanently,
                notes: "baz-bar"
            )
        )
        #expect(res.source == "/foo-bar")

        let query = DatabaseQueryExecutor(database: database) { context in
            GenericScope(
                [
                    "rule": RuleDatabaseQueries(context: context)
                ]
            )
        }

        let rule = try await query.run { ctx in
            ctx.rule
        }
        print(rule)

        let useCase2 = AddRule(
            authorizer: authorizer,
            transaction: transaction
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
