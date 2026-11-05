import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterApplication
import NewsletterDomain
public import NewsletterModule

extension Issue.Search.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Issue.Table>
        private let campaignAccessLayer: DatabaseAccessLayer<Campaign.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
            self.campaignAccessLayer = .init(context: context)
        }

        public func search(
            campaignKey: String,
            query: Issue.Search.Input.Query
        ) async throws -> Issue.Search.Output? {
            guard
                let campaign = try await campaignAccessLayer.selectFirst(
                    as: Campaign.Table.Detail.self,
                    { $0.where(\.key, equals: campaignKey) }
                )
            else { return nil }

            let items =
                try await accessLayer
                .select(as: Issue.Table.List.self) { initial in
                    paginatedQuery(
                        applyFilters(
                            query,
                            newsletterId: campaign.id,
                            to: initial
                        )
                        .order(by: databaseOrders(for: query.sort)),
                        using: query.page
                    )
                }
                .map { row in
                    guard let status = Issue.Model.Status(rawValue: row.status)
                    else {
                        throw RepositoryError.invalidEnumValue(row.status)
                    }
                    return Issue.Search.Output.Item(
                        id: row.id,
                        subject: row.subject,
                        status: status,
                        scheduledDate: row.scheduledDate,
                        createdAt: row.createdAt
                    )
                }
            let total = try await accessLayer.selectCount { initial in
                applyFilters(query, newsletterId: campaign.id, to: initial)
            }
            return .init(items: items, total: total)
        }

        private func applyFilters(
            _ query: Issue.Search.Input.Query,
            newsletterId: String,
            to initial: DatabaseQuerySelect<Issue.Table>
        ) -> DatabaseQuerySelect<Issue.Table> {
            var result = initial.where(\.newsletterId, equals: newsletterId)
            if let search = query.search, !search.isEmpty {
                result = result.where(
                    searchText: search,
                    columns: [DatabaseQueryTextColumn<Issue.Table>(\.subject)]
                )
            }
            return result
        }

        private func databaseOrders(
            for rules: [Issue.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Issue.Table>] {
            var orders = rules.map { rule in
                let direction: DatabaseQueryDirection =
                    rule.direction == .asc ? .ascending : .descending
                return switch rule.field {
                case .subject:
                    DatabaseQueryOrder<Issue.Table>(by: \.subject, direction)
                case .status:
                    DatabaseQueryOrder<Issue.Table>(by: \.status, direction)
                case .scheduledDate:
                    DatabaseQueryOrder<Issue.Table>(
                        by: \.scheduledDate,
                        direction
                    )
                case .createdAt:
                    DatabaseQueryOrder<Issue.Table>(by: \.createdAt, direction)
                }
            }
            if !rules.contains(where: { $0.field == .createdAt }) {
                orders.append(.init(by: \.createdAt, .descending))
            }
            if !rules.contains(where: { $0.field == .subject }) {
                orders.append(.init(by: \.subject, .ascending))
            }
            return orders
        }

        private func paginatedQuery(
            _ query: DatabaseQuerySelect<Issue.Table>,
            using page: FeatherApplication.Search.Page
        ) -> DatabaseQuerySelect<Issue.Table> {
            let page = page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max : pageIndex * page.size
            return query.limit(page.size).offset(offset)
        }
    }
}
