import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import NewsletterApplication
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Remove.Interactor {
    struct Default: Interface {
        let repository: any Subscriber.Remove.Repository.Interface

        func remove(ids: [String], campaignId: String?) async throws {
            try await repository.remove(ids: ids, campaignId: campaignId)
        }
    }
}
