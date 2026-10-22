import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

import struct Foundation.Date

extension Metadata.Table.Detail {
    var asDetail: Metadata.Detail.Output {
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

extension Metadata {
    public enum Query {}
}

extension Metadata.Query {
    public struct Database: Metadata.Detail.Query.Interface,
        Metadata.Reference.Query.Interface,
        Metadata.Resolve.Query.Interface,
        Metadata.Resolve.Detail.Query.Interface,
        WebRoute.Resolve.Query.Interface
    {
        public let context: DatabaseQueryContext
        private var accessLayer: DatabaseAccessLayer<Metadata.Table> {
            .init(context: context)
        }

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Metadata.Detail.Output {
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
        ) async throws -> Metadata.Detail.Output? {
            try await accessLayer.selectFirst(as: Metadata.Table.Detail.self) {
                $0.where(\.referenceType, equals: referenceType)
                    .where(\.referenceID, equals: referenceID)
                    .limit(1)
            }
            .map { $0.asDetail }
        }

        public func resolve(slug: String) async throws -> Metadata.Detail
            .Output?
        {
            try await accessLayer.selectFirst(by: \.slug, equals: slug)
                .map { $0.asDetail }
        }

        public func resolve(
            referenceType: String,
            referenceIDs: [String]
        ) async throws -> [Metadata.List.Output.Item] {
            guard !referenceIDs.isEmpty else { return [] }
            let rows = try await accessLayer.select(
                as: Metadata.Table.List.self
            ) {
                $0.where(\.referenceType, equals: referenceType)
                    .where(\.referenceID, in: referenceIDs)
                    .order(by: \.referenceID, .ascending)
            }
            return rows.map(\.asListItem)
        }

        public func resolveDetails(
            referenceType: String,
            referenceIDs: [String]
        ) async throws -> [Metadata.Detail.Output] {
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

    }
}
