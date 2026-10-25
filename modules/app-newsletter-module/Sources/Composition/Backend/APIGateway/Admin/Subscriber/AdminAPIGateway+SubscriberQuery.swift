import FeatherApplication
import FeatherModuleKit
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain
import NewsletterModule

extension AdminAPIGateway {
    public func newsletterSubscriberQuery(
        _ input: Operations.NewsletterSubscriberQuery.Input
    ) async throws -> Operations.NewsletterSubscriberQuery.Output {
        let request:
            Components.Schemas
                .NewsletterSubscriberQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            request = value
        }

        let defaults = FeatherApplication.Search.Page()
        let page = FeatherApplication.Search
            .Page(
                size: request.page?.size ?? defaults.size,
                number: request.page?.number ?? defaults.number
            )
            .normalized()
        let sort = (request.sort ?? [])
            .map { rule in
                Subscriber.Search.Input.Query.Sort(
                    field: .email,
                    direction: rule.direction == .asc ? .asc : .desc
                )
            }

        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeSearchSubscribers()
            .execute(
                subject: subject,
                input: .init(
                    query: .init(
                        page: page,
                        sort: sort,
                        search: request.filters.search,
                        campaignKey: request.filters.campaignKey,
                        email: request.filters.email
                    )
                )
            )

        let responseSort = request.sort?
            .map { rule in
                Components.Schemas
                    .NewsletterSubscriberQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(
                        field: .email,
                        direction: rule.direction
                    )
            }
        return .ok(
            .init(
                body: .json(
                    .init(
                        query: .init(
                            page: .init(size: page.size, number: page.number),
                            sort: responseSort,
                            filters: .init(
                                search: request.filters.search,
                                campaignKey: request.filters.campaignKey,
                                email: request.filters.email
                            )
                        ),
                        data: .init(
                            items: result.items.map { item in
                                Components.Schemas
                                    .NewsletterSubscriberQueryItemSchema(
                                        email: item.email,
                                        name: item.name,
                                        memberships: item.memberships.map {
                                            Components.Schemas
                                                .NewsletterSubscriberQueryMembershipSchema(
                                                    campaignKey: $0.campaignKey,
                                                    campaignName: $0
                                                        .campaignName,
                                                    status: $0.status.rawValue
                                                )
                                        }
                                    )
                            },
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}
