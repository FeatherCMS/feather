import FeatherDatabase
import FeatherInfrastructure
import Foundation
import SystemApplication

private struct JobRow {
    let id: String
    let queueName: String
    let status: Int
    let workerId: String?
    let lastModified: Date
    let payload: String

    init(from row: DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        queueName = try row.decode(column: "queue_name", as: String.self)
        status = try row.decode(column: "status", as: Int.self)
        workerId = try row.decode(column: "worker_id", as: String?.self)
        lastModified = try row.decode(column: "last_modified", as: Date.self)
        payload = try row.decode(column: "payload", as: String.self)
    }

    var detail: JobDetail {
        .init(
            id: id,
            queueName: queueName,
            status: status,
            workerId: workerId,
            lastModified: lastModified,
            payload: payload
        )
    }
}

public struct JobDatabaseQueries: JobQueries {
    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
    }

    public func list() async throws -> [JobDetail] {
        try await context.connection.run(
            query: #"""
                SELECT id::text, queue_name, status, worker_id, last_modified,
                       convert_from(job, 'UTF8') AS payload
                FROM swift_jobs.jobs
                ORDER BY last_modified DESC;
                """#
        ) { sequence in
            try await sequence.collect().map { try JobRow(from: $0).detail }
        }
    }

    public func find(id: String) async throws -> JobDetail {
        try await context.connection.run(
            query: #"""
                SELECT id::text, queue_name, status, worker_id, last_modified,
                       convert_from(job, 'UTF8') AS payload
                FROM swift_jobs.jobs
                WHERE id = \#(id)::uuid
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw SystemInfrastructureError.notFound
            }
            return try JobRow(from: row).detail
        }
    }
}

enum SystemInfrastructureError: Error {
    case notFound
}
