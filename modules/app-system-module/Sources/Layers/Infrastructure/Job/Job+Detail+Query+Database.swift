import FeatherDatabase
public import FeatherInfrastructure
public import SystemApplication
public import SystemModule

extension SystemModule.Job.Detail.Query {
    public struct Database: SystemModule.Job.Detail.Query.Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(
            id: String
        ) async throws -> SystemModule.Job.Detail.Output {
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
                    throw QueryError.notFound
                }
                return try JobRow(from: row).detail
            }
        }
    }
}
