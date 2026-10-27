//
//  Metadata+Repository+Database.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import WebDomain
public import WebModule

extension Metadata.Table.Detail {

    var asDomain: Metadata.Model {
        .init(
            id: id,
            reference: .identified(.init(type: referenceType, id: referenceID)),
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
            templateData: templateData,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Metadata.Repository {
    public struct Database: Interface {

        public let context: DatabaseTransactionContext
        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(
            _ model: Metadata.Model.New
        ) async throws -> Metadata.Model {

            guard let referenceID = model.reference.id else {
                throw RepositoryError(
                    reason: .unknown,
                    logMessage: "Metadata reference identifier is missing.",
                    userFriendlyMessage:
                        "Metadata reference identifier is missing."
                )
            }

            let accessLayer = DatabaseAccessLayer<Metadata.Table>(
                context: context
            )
            let id = context.idGenerator.generate()
            try await accessLayer.insert(
                Metadata.Table.Insert(
                    id: id,
                    referenceType: model.reference.type,
                    referenceID: referenceID,
                    template: model.template,
                    slug: model.slug,
                    publicationDate: model.publicationDate,
                    expirationDate: model.expirationDate,
                    status: model.status.rawValue,
                    titleOverride: model.title,
                    excerptOverride: model.excerpt,
                    imageURLOverride: model.imageURL,
                    canonicalURL: model.canonicalURL,
                    noIndex: model.noIndex,
                    primaryKeyword: model.primaryKeyword,
                    cssCodeInjection: model.cssCodeInjection,
                    javascriptCodeInjection: model.javascriptCodeInjection,
                    structuredDataCodeInjection: model
                        .structuredDataCodeInjection,
                    templateData: model.templateData
                )
            )
            guard
                let saved = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
            return saved.asDomain
        }

        public func find(
            id: String
        ) async throws -> Metadata.Model? {
            try await DatabaseAccessLayer<Metadata.Table>(context: context)
                .selectFirst(by: \.id, equals: id)
                .map { $0.asDomain }
        }

        public func find(
            slug: String
        ) async throws -> Metadata.Model? {
            try await DatabaseAccessLayer<Metadata.Table>(context: context)
                .selectFirst(by: \.slug, equals: slug)
                .map { $0.asDomain }
        }

        public func find(
            referenceType: String,
            referenceId: String
        ) async throws -> Metadata.Model? {
            let accessLayer = DatabaseAccessLayer<Metadata.Table>(
                context: context
            )
            return
                try await accessLayer.selectFirst(
                    as: Metadata.Table.Detail.self
                ) {
                    $0.where(\.referenceType, equals: referenceType)
                        .where(\.referenceID, equals: referenceId)
                        .limit(1)
                }
                .map { $0.asDomain }
        }

        public func update(
            _ model: Metadata.Model
        ) async throws -> Metadata.Model {
            guard let referenceID = model.reference.id else {
                throw RepositoryError(
                    reason: .unknown,
                    logMessage: "Metadata reference identifier is missing.",
                    userFriendlyMessage:
                        "Metadata reference identifier is missing."
                )
            }

            let accessLayer = DatabaseAccessLayer<Metadata.Table>(
                context: context
            )
            try await accessLayer.update(
                Metadata.Table.Update(
                    referenceType: model.reference.type,
                    referenceID: referenceID,
                    template: model.template,
                    slug: model.slug,
                    publicationDate: model.publicationDate,
                    expirationDate: model.expirationDate,
                    status: model.status.rawValue,
                    titleOverride: model.title,
                    excerptOverride: model.excerpt,
                    imageURLOverride: model.imageURL,
                    canonicalURL: model.canonicalURL,
                    noIndex: model.noIndex,
                    primaryKeyword: model.primaryKeyword,
                    cssCodeInjection: model.cssCodeInjection,
                    javascriptCodeInjection: model.javascriptCodeInjection,
                    structuredDataCodeInjection: model
                        .structuredDataCodeInjection,
                    templateData: model.templateData
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let updated = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return updated.asDomain
        }

        public func delete(
            ids: [String]
        ) async throws -> [String] {
            try await DatabaseAccessLayer<Metadata.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }

        public func delete(
            referenceType: String,
            referenceIds: [String]
        ) async throws -> [String] {
            guard !referenceIds.isEmpty else {
                return []
            }
            let accessLayer = DatabaseAccessLayer<Metadata.Table>(
                context: context
            )
            let filter = DatabaseQueryFilter<Metadata.Table>()
                .where(\.referenceType, equals: referenceType)
                .where(\.referenceID, in: referenceIds)
            let rows = try await accessLayer.select(
                as: Metadata.Table.List.self
            ) {
                $0.where(filter)
            }
            try await accessLayer.delete(where: filter)
            return rows.map(\.id)
        }
    }
}
