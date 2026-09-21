import FeatherAdmin
import FeatherContracts
import Foundation
import SystemAdminAPI

struct AdminListSystemJobDefaultInteractor: AdminListSystemJobInteractor {
    let repository: any AdminListSystemJobRepository

    func list(
        page: Int,
        search: String?,
        status: Int?
    ) async throws -> AdminListSystemJobModel {
        let allJobs: [Components.Schemas.SystemJobSchema]
        do {
            allJobs = try await repository.list()
        }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .unauthorized: throw AdminListSystemJobError.unauthorized
            case .forbidden: throw AdminListSystemJobError.forbidden
            case .failure, .transport, .notFound, .conflict:
                throw AdminListSystemJobError.unavailable
            }
        }
        let normalizedSearch = search?.emptyToNil ?? ""
        let filteredJobs = allJobs.filter { job in
            guard status == nil || job.status == status else { return false }
            guard !normalizedSearch.isEmpty else { return true }
            return [
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
        let sortedJobs = filteredJobs.sorted { lhs, rhs in
            let left = SystemJobPayload(job: lhs).queuedAtTimestamp
            let right = SystemJobPayload(job: rhs).queuedAtTimestamp
            switch (left, right) {
            case (let left?, let right?):
                if left != right { return left > right }
                return lhs.id > rhs.id
            case (_?, nil): return true
            case (nil, _?): return false
            case (nil, nil): return lhs.id > rhs.id
            }
        }
        let pageSize = AdminListSystemJob.pageSize
        let normalizedPage = max(1, page)
        let start = (normalizedPage - 1) * pageSize
        let items =
            start < sortedJobs.count
            ? Array(
                sortedJobs[start..<min(start + pageSize, sortedJobs.count)]
            )
            : []
        return .init(
            items: items,
            pageState: .init(
                page: normalizedPage,
                pageSize: pageSize,
                total: sortedJobs.count
            )
        )
    }
}
