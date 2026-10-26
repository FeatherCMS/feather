import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import NewsletterApplication
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
            let normalizedSearch =
                search?.whitespaceTrimmed ?? ""
            let result = try await repository.search(
                search: normalizedSearch,
                campaignKey: campaignId,
                page: page
            )
            let pageSize = 20
            return .init(
                items: result.items,
                campaigns: campaigns,
                search: normalizedSearch,
                campaignId: campaignId ?? "",
                pageState: .init(
                    page: page,
                    pageSize: pageSize,
                    total: result.total
                )
            )
        }

    }
}
