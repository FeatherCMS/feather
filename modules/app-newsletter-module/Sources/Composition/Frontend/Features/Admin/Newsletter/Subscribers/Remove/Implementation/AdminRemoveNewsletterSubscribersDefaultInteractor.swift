import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterSubscribersDefaultInteractor:
    AdminRemoveNewsletterSubscribersInteractor
{
    let repository: AdminRemoveNewsletterSubscribersOpenAPIRepository

    func names(ids: [String]) async throws -> [String] {
        try await repository.names(ids: ids)
    }

    func remove(ids: [String], campaignId: String?) async throws {
        try await repository.remove(ids: ids, campaignId: campaignId)
    }
}
