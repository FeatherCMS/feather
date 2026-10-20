import FeatherAdmin
import FeatherModuleKit
import Foundation
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Job.List.Interactor {
    struct Default: WebAdmin.System.Job.List.Interactor.Interface {
        let repository: any WebAdmin.System.Job.List.Repository.Interface

        func list(
            page: Int,
            search: String?,
            status: Int?
        ) async throws -> WebAdmin.System.Job.List.Model {
            let allJobs: [Components.Schemas.SystemJobSchema]
            do {
                allJobs = try await repository.list()
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .unauthorized:
                    throw WebAdmin.System.Job.List.Error.unauthorized
                case .forbidden: throw WebAdmin.System.Job.List.Error.forbidden
                case .failure, .transport, .notFound, .conflict:
                    throw WebAdmin.System.Job.List.Error.unavailable
                }
            }
            let normalizedSearch = search?.emptyToNil ?? ""
            let filteredJobs = allJobs.filter { job in
                guard status == nil || job.status == status else {
                    return false
                }
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
            let pageSize = WebAdmin.System.Job.List.Router.pageSize
            let normalizedPage = max(1, page)
            let pageIndex = normalizedPage - 1
            let start =
                pageIndex > Int.max / pageSize
                ? Int.max
                : pageIndex * pageSize
            let items =
                start < sortedJobs.count
                ? Array(
                    sortedJobs[
                        start..<start + min(pageSize, sortedJobs.count - start)
                    ]
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
}
