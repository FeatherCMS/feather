import FeatherAdmin
import Foundation

struct AdminListNewsletterIssuesDefaultInteractor:
    AdminListNewsletterIssuesInteractor
{
    let repository: AdminListNewsletterIssuesOpenAPIRepository

    func list(
        newsletterId: String,
        page: Int,
        search: String?
    ) async throws -> NewAdminListModel<AdminNewsletterIssueItem> {
        let query =
            search?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let allItems = try await repository.list(newsletterId: newsletterId)
            .filter {
                query.isEmpty
                    || $0.subject.localizedCaseInsensitiveContains(query)
            }
        let pageSize = 20
        let start = max(0, (page - 1) * pageSize)
        return .init(
            items: Array(allItems.dropFirst(start).prefix(pageSize)),
            pageState: .init(
                page: page,
                pageSize: pageSize,
                total: allItems.count
            )
        )
    }
}
