import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.List.Interactor {
    struct Default: Interface {
        let repository: any Subscriber.List.Repository.Interface

        func list(search: String?, campaignId: String?, page: Int) async throws
            -> Subscriber.List.Model
        {
            let campaigns = try await repository.campaigns()
            let items = try await repository.list()
            let normalizedSearch =
                search?.whitespaceTrimmed ?? ""
            let filtered = items.filter {
                (normalizedSearch.isEmpty
                    || $0.email.localizedCaseInsensitiveContains(
                        normalizedSearch
                    )
                    || $0.name.localizedCaseInsensitiveContains(
                        normalizedSearch
                    ))
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

        func get(id: String) async throws -> Subscriber.List.Model.Item {
            try await repository.get(id: id)
        }

    }
}
