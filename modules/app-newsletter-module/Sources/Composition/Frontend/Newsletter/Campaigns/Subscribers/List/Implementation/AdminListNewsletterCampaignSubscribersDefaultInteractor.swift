import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListNewsletterCampaignSubscribersDefaultInteractor:
    AdminListNewsletterCampaignSubscribersInteractor
{
    let repository: AdminListNewsletterCampaignSubscribersOpenAPIRepository
    func list(newsletterId: String, search: String?) async throws
        -> [AdminNewsletterCampaignSubscriberItem]
    {
        let items = try await repository.list(newsletterId: newsletterId)
        guard let search, !search.isEmpty else { return items }
        let query = search.lowercased()
        return items.filter {
            $0.email.lowercased().contains(query)
                || $0.firstName.lowercased().contains(query)
                || $0.lastName.lowercased().contains(query)
                || $0.status.lowercased().contains(query)
        }
    }
}
