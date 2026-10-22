import FeatherWebAdmin
import FeatherModuleKit
import Foundation

struct AdminListNewsletterCampaignsDefaultInteractor:
    AdminListNewsletterCampaignsInteractor
{
    let repository: AdminListNewsletterCampaignsOpenAPIRepository

    func list(
        page: Int,
        search: String?
    ) async throws -> AdminListModel<AdminNewsletterCampaignItem> {
        let query =
            search?.whitespaceTrimmed ?? ""
        let allItems = try await repository.list()
            .filter {
                query.isEmpty || $0.name.localizedCaseInsensitiveContains(query)
            }
        let pageSize = 20
        let start = max(0, (page - 1) * pageSize)
        let items = Array(allItems.dropFirst(start).prefix(pageSize))
        return .init(
            items: items,
            pageState: .init(
                page: page,
                pageSize: pageSize,
                total: allItems.count
            )
        )
    }
}
