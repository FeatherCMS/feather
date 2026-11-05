import FeatherApplication
import FeatherModuleKit
import Foundation
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain
import NewsletterModule

extension AdminAPIGateway {
    public func newsletterIssueQuery(
        _ input: Operations.NewsletterIssueQuery.Input
    ) async throws -> Operations.NewsletterIssueQuery.Output {
        let request:
            Components.Schemas.NewsletterIssueQueryItemSearchRequestQuerySchema
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
                let field: Issue.Search.Input.Query.Sort.Field =
                    switch rule.field {
                    case .subject: .subject
                    case .status: .status
                    case .scheduledAt: .scheduledDate
                    case .createdAt: .createdAt
                    }
                return Issue.Search.Input.Query.Sort(
                    field: field,
                    direction: rule.direction == .asc ? .asc : .desc
                )
            }

        let subject = try await CurrentSubject.require()
        let campaignKey = try await campaignKey(
            for: input.path.newsletterCampaignId,
            subject: subject
        )
        let result = try await useCases.makeSearchIssues()
            .execute(
                subject: subject,
                input: .init(
                    campaignKey: campaignKey,
                    query: .init(
                        page: page,
                        sort: sort,
                        search: request.filters.search
                    )
                )
            )

        let responseSort = request.sort?
            .map { rule in
                let field:
                    Components.Schemas
                        .NewsletterIssueQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload =
                            switch rule.field {
                            case .subject: .subject
                            case .status: .status
                            case .scheduledAt: .scheduledAt
                            case .createdAt: .createdAt
                            }
                return Components.Schemas
                    .NewsletterIssueQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(
                        field: field,
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
                            filters: .init(search: request.filters.search)
                        ),
                        data: .init(
                            items: result.items.map { item in
                                Components.Schemas
                                    .NewsletterIssueQueryItemSchema(
                                        id: item.id,
                                        subject: item.subject,
                                        status: item.status.rawValue,
                                        scheduledAt: item.scheduledDate.map {
                                            $0.timeIntervalSince1970
                                        },
                                        createdAt: item.createdAt
                                            .timeIntervalSince1970
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
