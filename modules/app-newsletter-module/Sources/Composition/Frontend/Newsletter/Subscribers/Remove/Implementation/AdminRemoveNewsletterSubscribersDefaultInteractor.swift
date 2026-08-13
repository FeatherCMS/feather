import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveNewsletterSubscribersDefaultInteractor:
    AdminRemoveNewsletterSubscribersInteractor
{
    let repository: AdminRemoveNewsletterSubscribersOpenAPIRepository

    func remove(ids: [String], campaignId: String?) async throws {
        try await repository.remove(ids: ids, campaignId: campaignId)
    }
}
