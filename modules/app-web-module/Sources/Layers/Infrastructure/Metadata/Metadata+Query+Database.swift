import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
public import WebDomain

import struct Foundation.Date

extension Metadata.Table.List {
    var asQueryListItem: MetadataList.Item {
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

extension Metadata.Table.Detail {
    var asDetail: MetadataDetail {
        .init(
            id: id,
            referenceType: referenceType,
            referenceID: referenceID,
            template: template,
            slug: slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: .init(rawValue: status) ?? .draft,
            title: titleOverride,
            excerpt: excerptOverride,
            imageURL: imageURLOverride,
            canonicalURL: canonicalURL,
            noIndex: noIndex,
            primaryKeyword: primaryKeyword,
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Metadata.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext
        private var accessLayer: DatabaseAccessLayer<Metadata.Table> {
            .init(context: context)
        }

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> MetadataDetail {
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
            return row.asDetail
        }

        public func find(
            referenceType: String,
            referenceID: String
        ) async throws -> MetadataDetail? {
            try await accessLayer.selectFirst(as: Metadata.Table.Detail.self) {
                $0.where(\.referenceType, equals: referenceType)
                    .where(\.referenceID, equals: referenceID)
                    .limit(1)
            }
            .map { $0.asDetail }
        }

        public func find(
            referenceType: String,
            slug: String
        ) async throws -> MetadataDetail? {
            try await accessLayer.selectFirst(as: Metadata.Table.Detail.self) {
                $0.where(\.referenceType, equals: referenceType)
                    .where(\.slug, equals: slug)
                    .limit(1)
            }
            .map { $0.asDetail }
        }

        public func resolve(slug: String) async throws -> MetadataDetail? {
            try await accessLayer.selectFirst(by: \.slug, equals: slug)
                .map { $0.asDetail }
        }

        public func listPublic() async throws -> [MetadataList.Item] {
            let now = Date()
            let availability = DatabaseQueryFilter<Metadata.Table>()
                .isNull(\.expirationDate)
                .or { $0.where(\.expirationDate, greaterThan: now) }
            let rows = try await accessLayer.select(
                as: Metadata.Table.List.self
            ) {
                $0.where(\.status, equals: "published")
                    .where(\.publicationDate, lessThanOrEqualTo: now)
                    .where(availability)
                    .where(\.noIndex, equals: false)
                    .order(by: \.slug, .ascending)
                    .order(by: \.id, .ascending)
            }
            return rows.map(\.asQueryListItem)
        }

        public func list(
            query: MetadataList.Query
        ) async throws -> MetadataList {
            let items = try await accessLayer.select(
                as: Metadata.Table.List.self
            ) {
                paginated(
                    applyFilters(query, to: $0)
                        .order(by: orders(for: query.sort)),
                    page: query.page
                )
            }
            return .init(items: items.map(\.asQueryListItem))
        }

        public func resolve(
            referenceType: String,
            referenceIDs: [String]
        ) async throws -> [MetadataList.Item] {
            guard !referenceIDs.isEmpty else { return [] }
            let rows = try await accessLayer.select(
                as: Metadata.Table.List.self
            ) {
                $0.where(\.referenceType, equals: referenceType)
                    .where(\.referenceID, in: referenceIDs)
                    .order(by: \.referenceID, .ascending)
            }
            return rows.map(\.asQueryListItem)
        }

        public func resolveDetails(
            referenceType: String,
            referenceIDs: [String]
        ) async throws -> [MetadataDetail] {
            guard !referenceIDs.isEmpty else { return [] }
            let rows = try await accessLayer.select(
                as: Metadata.Table.Detail.self
            ) {
                $0.where(\.referenceType, equals: referenceType)
                    .where(\.referenceID, in: referenceIDs)
                    .order(by: \.referenceID, .ascending)
            }
            return rows.map(\.asDetail)
        }

        public func count(query: MetadataList.Query) async throws -> Int {
            try await accessLayer.selectCount { applyFilters(query, to: $0) }
        }

        private func applyFilters(
            _ query: MetadataList.Query,
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
            for rules: [MetadataList.Query.Sort]
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
            page: Search.Page
        ) -> DatabaseQuerySelect<Metadata.Table> {
            let page = page.normalized()
            let index = page.number - 1
            let offset =
                index > Int.max / page.size ? Int.max : index * page.size
            return query.limit(page.size).offset(offset)
        }
    }
}
