import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterSubscribersDefaultInteractor:
    AdminListNewsletterSubscribersInteractor
{
    let repository: AdminListNewsletterSubscribersOpenAPIRepository

    func list(search: String?, campaignId: String?, page: Int) async throws
        -> AdminNewsletterSubscribersListModel
    {
        let campaigns = try await repository.campaigns()
        let items = try await repository.list()
        let normalizedSearch =
            search?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let filtered = items.filter {
            (normalizedSearch.isEmpty
                || $0.email.localizedCaseInsensitiveContains(normalizedSearch)
                || $0.name.localizedCaseInsensitiveContains(normalizedSearch))
                && (campaignId?.isEmpty != false
                    || $0.newsletters.contains { $0.id == campaignId })
        }
        let pageSize = 20
        let start = max(0, (page - 1) * pageSize)
        return .init(
            items: Array(filtered.dropFirst(start).prefix(pageSize)),
            campaigns: campaigns,
            search: normalizedSearch,
            campaignId: campaignId ?? "",
            pageState: .init(
                page: page,
                pageSize: pageSize,
                total: filtered.count
            )
        )
    }
}
