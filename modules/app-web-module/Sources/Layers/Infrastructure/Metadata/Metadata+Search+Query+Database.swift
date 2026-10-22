public import WebApplication
public import WebDomain
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure

import struct Foundation.Date

extension Metadata.Table.List {
    var asSearchItem: Metadata.Search.Output.Item {
        .init(
            id: id,
            referenceType: referenceType,
            referenceID: referenceID,
            slug: slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: .init(rawValue: status) ?? .draft,
            title: titleOverride ?? "",
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Metadata.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(query: Metadata.Search.Input.Query) async throws
            -> Metadata.Search.Output
        {
            let accessLayer = DatabaseAccessLayer<Metadata.Table>(
                context: context
            )
            let items = try await accessLayer.select(
                as: Metadata.Table.List.self
            ) {
                paginated(
                    applyFilters(query, to: $0)
                        .order(by: orders(for: query.sort)),
                    page: query.page
                )
            }
            let total = try await accessLayer.selectCount {
                applyFilters(query, to: $0)
            }
            return .init(items: items.map(\.asSearchItem), total: total)
        }

        private func applyFilters(
            _ query: Metadata.Search.Input.Query,
            to initial: DatabaseQuerySelect<Metadata.Table>
        ) -> DatabaseQuerySelect<Metadata.Table> {
            var result = initial
            if let referenceType = query.referenceType {
                result = result.where(\.referenceType, equals: referenceType)
            }
            if let search = query.search {
                result = result.where(
                    searchText: search,
                    columns: [
                        .init(\.id),
                        .init(\.referenceType),
                        .init(\.referenceID),
                        .init(\.slug),
                        .init(\.status),
                        .init(\.titleOverride),
                        .init(\.excerptOverride),
                        .init(\.imageURLOverride),
                        .init(\.canonicalURL),
                        .init(\.primaryKeyword),
                    ]
                )
            }
            return result
        }

        private func orders(
            for rules: [Metadata.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Metadata.Table>] {
            var result = rules.map { rule in
                let direction: DatabaseQueryDirection =
                    rule.direction == .asc ? .ascending : .descending
                return switch rule.field {
                case .id:
                    DatabaseQueryOrder<Metadata.Table>(by: \.id, direction)
                case .referenceType:
                    DatabaseQueryOrder<Metadata.Table>(
                        by: \.referenceType,
                        direction
                    )
                case .referenceID:
                    DatabaseQueryOrder<Metadata.Table>(
                        by: \.referenceID,
                        direction
                    )
                case .slug:
                    DatabaseQueryOrder<Metadata.Table>(by: \.slug, direction)
                case .publicationDate:
                    DatabaseQueryOrder<Metadata.Table>(
                        by: \.publicationDate,
                        direction
                    )
                case .expirationDate:
                    DatabaseQueryOrder<Metadata.Table>(
                        by: \.expirationDate,
                        direction
                    )
                case .status:
                    DatabaseQueryOrder<Metadata.Table>(by: \.status, direction)
                case .title:
                    DatabaseQueryOrder<Metadata.Table>(
                        by: \.titleOverride,
                        direction
                    )
                case .createdAt:
                    DatabaseQueryOrder<Metadata.Table>(
                        by: \.createdAt,
                        direction
                    )
                case .updatedAt:
                    DatabaseQueryOrder<Metadata.Table>(
                        by: \.updatedAt,
                        direction
                    )
                }
            }
            if !rules.contains(where: { $0.field == .id }) {
                result.append(.init(by: \.id, .ascending))
            }
            return result
        }

        private func paginated(
            _ query: DatabaseQuerySelect<Metadata.Table>,
            page: FeatherApplication.Search.Page
        ) -> DatabaseQuerySelect<Metadata.Table> {
            let page = page.normalized()
            let index = page.number - 1
            let offset =
                index > Int.max / page.size ? Int.max : index * page.size
            return query.limit(page.size).offset(offset)
        }
    }
}
