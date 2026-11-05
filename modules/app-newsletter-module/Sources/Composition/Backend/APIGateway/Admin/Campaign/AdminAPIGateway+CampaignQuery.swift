import FeatherApplication
import FeatherModuleKit
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule

extension AdminAPIGateway {
    public func newsletterCampaignQuery(
        _ input: Operations.NewsletterCampaignQuery.Input
    ) async throws -> Operations.NewsletterCampaignQuery.Output {
        let query:
            Components.Schemas
                .NewsletterCampaignQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let page = searchPage(from: query)
        let sort = (query.sort ?? [])
            .map { rule in
                Campaign.Search.Input.Query.Sort(
                    field: rule.field == .key ? .key : .name,
                    direction: searchSortDirection(from: rule.direction)
                )
            }
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeSearchCampaigns()
            .execute(
                subject: subject,
                input: .init(
                    query: .init(
                        page: page,
                        sort: sort,
                        search: query.filters.search
                    )
                )
            )

        let responseSort = query.sort.map { rules in
            rules.map { rule in
                Components.Schemas
                    .NewsletterCampaignQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(
                        field: rule.field == .key ? .key : .name,
                        direction: rule.direction
                    )
            }
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        query: .init(
                            page: .init(size: page.size, number: page.number),
                            sort: responseSort,
                            filters: .init(search: query.filters.search)
                        ),
                        data: .init(
                            items: result.items.map { item in
                                Components.Schemas
                                    .NewsletterCampaignQueryItemSchema(
                                        id: item.id,
                                        key: item.key,
                                        name: item.name,
                                        fromEmail: item.fromEmail,
                                        subscriberCount: item.subscriberCount,
                                        sentIssueCount: item.sentIssueCount
                                    )
                            },
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func searchPage(
        from query: Components.Schemas
            .NewsletterCampaignQueryItemSearchRequestQuerySchema
    ) -> FeatherApplication.Search.Page {
        let defaults = FeatherApplication.Search.Page()
        return FeatherApplication.Search
            .Page(
                size: query.page?.size ?? defaults.size,
                number: query.page?.number ?? defaults.number
            )
            .normalized()
    }

    private func searchSortDirection(
        from direction: Components.Schemas.SortDirection
    ) -> FeatherApplication.Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }
}
