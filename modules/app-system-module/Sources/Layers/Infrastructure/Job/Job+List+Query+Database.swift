public import SystemModule
public import FeatherApplication
import FeatherDatabase
public import FeatherInfrastructure
public import SystemApplication

extension SystemModule.Job.List.Query {
    public struct Database: SystemModule.Job.List.Query.Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list(
            page: Search.Page
        ) async throws -> SystemModule.Job.List.Output {
            let pageSize = min(max(1, page.size), 100)
            let pageNumber = max(1, page.number)
            let pageIndex = pageNumber - 1
            let offset =
                pageIndex > Int.max / pageSize
                ? Int.max
                : pageIndex * pageSize
            let items = try await context.connection.run(
                query: #"""
                    SELECT id::text, queue_name, status, worker_id, last_modified,
                           convert_from(job, 'UTF8') AS payload
                    FROM swift_jobs.jobs
                    ORDER BY last_modified DESC, id DESC
                    LIMIT \#(pageSize) OFFSET \#(offset);
                    """#
            ) { sequence in
                try await sequence.collect().map { try JobRow(from: $0).detail }
            }
            return .init(items: items)
        }
    }
}
