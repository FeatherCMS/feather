import FeatherAdmin
import Foundation
import SystemAdminAPI

struct AdminListSystemJobDefaultInteractor: AdminListSystemJobInteractor {
    let repository: any AdminListSystemJobRepository

    func list(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemJobModel {
        let allJobs = try await repository.list()
        let normalizedSearch =
            search?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let filteredJobs =
            normalizedSearch.isEmpty
            ? allJobs
            : allJobs.filter { job in
                [
                    job.id,
                    job.queueName,
                    job.workerId ?? "",
                    String(job.status),
                    job.payload,
                ]
                .contains {
                    $0.localizedCaseInsensitiveContains(normalizedSearch)
                }
            }
        let pageSize = 20
        let normalizedPage = max(1, page)
        let start = (normalizedPage - 1) * pageSize
        let items =
            start < filteredJobs.count
            ? Array(
                filteredJobs[start..<min(start + pageSize, filteredJobs.count)]
            )
            : []
        return .init(
            items: items,
            total: filteredJobs.count,
            page: normalizedPage,
            pageSize: pageSize
        )
    }
}
