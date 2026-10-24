import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.List {
    enum Repository {}
}

extension Subscriber.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func campaigns() async throws -> [Subscriber.List.Model.Campaign] {
            try await Client(api: api).campaigns()
        }

        func search(
            search: String?,
            campaignKey: String?,
            page: Int
        ) async throws -> SearchResult {
            try await Client(api: api)
                .search(
                    search: search,
                    campaignKey: campaignKey,
                    page: page
                )
        }

        func list() async throws -> [Subscriber.List.Model.Item] {
            try await Client(api: api).list()
        }

        func get(id: String) async throws -> Subscriber.List.Model.Item {
            try await Client(api: api).get(id: id)
        }
    }
}
