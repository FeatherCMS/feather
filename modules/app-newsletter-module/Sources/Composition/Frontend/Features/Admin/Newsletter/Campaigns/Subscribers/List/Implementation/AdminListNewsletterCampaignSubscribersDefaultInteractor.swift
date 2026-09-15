import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterCampaignSubscribersDefaultInteractor:
    AdminListNewsletterCampaignSubscribersInteractor
{
    let repository: AdminListNewsletterCampaignSubscribersOpenAPIRepository
    func list(newsletterId: String, search: String?, page: Int) async throws
        -> NewAdminListModel<AdminNewsletterCampaignSubscriberItem>
    {
        let items = try await repository.list(newsletterId: newsletterId)
        let query = search?.lowercased() ?? ""
        let filtered =
            query.isEmpty
            ? items
            : items.filter {
                $0.email.lowercased().contains(query)
                    || $0.firstName.lowercased().contains(query)
                    || $0.lastName.lowercased().contains(query)
                    || $0.status.lowercased().contains(query)
            }
        let pageSize = 20
        let start = max(0, (page - 1) * pageSize)
        return .init(
            items: Array(filtered.dropFirst(start).prefix(pageSize)),
            pageState: .init(
                page: page,
                pageSize: pageSize,
                total: filtered.count
            )
        )
    }
}
