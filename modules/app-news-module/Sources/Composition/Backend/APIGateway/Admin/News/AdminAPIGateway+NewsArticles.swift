import FeatherApplication
import FeatherModuleKit
import Foundation
public import NewsAdminAPI
import NewsApplication
import NewsDomain
import NewsModule
import WebApplication
import WebModule

extension AdminAPIGateway {
    public func newsArticlePost(
        _ input: Operations.NewsArticlePost.Input
    ) async throws -> Operations.NewsArticlePost.Output {
        let body: Components.Schemas.NewsArticleCreateSchema =
            switch input.body {
            case .json(let value): value
            }
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeAddArticle()
            .execute(
                subject: subject,
                input: body.addArticleInput()
            )
        return .created(.init(body: .json(map(result))))
    }

    public func newsArticleList(
        _: Operations.NewsArticleList.Input
    ) async throws -> Operations.NewsArticleList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListArticles()
            .execute(
                subject: subject,
                input: .init(query: .init())
            )
        return .ok(.init(body: .json(result.items.map(map))))
    }

    public func newsArticleQuery(
        _ input: Operations.NewsArticleQuery.Input
    ) async throws -> Operations.NewsArticleQuery.Output {
        let query:
            Components.Schemas.NewsArticleQueryItemSearchRequestQuerySchema =
                switch input.body {
                case .json(let value): value
                }
        let subject = try await CurrentSubject.require()
        let objectQuery = Article.Search.Input.Query(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            search: query.filters.search
        )
        let useCase = useCases.makeSearchArticles()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        return .ok(
            .init(
                body: .json(
                    .init(
                        query: query.asResponse,
                        data: .init(
                            items: result.items.map(mapSearch),
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    public func newsArticleGet(
        _ input: Operations.NewsArticleGet.Input
    ) async throws -> Operations.NewsArticleGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeGetArticle()
            .execute(
                subject: subject,
                input: .init(id: input.path.newsArticleId)
            )
        return .ok(.init(body: .json(map(result))))
    }

    public func newsArticlePut(
        _ input: Operations.NewsArticlePut.Input
    ) async throws -> Operations.NewsArticlePut.Output {
        let body: Components.Schemas.NewsArticleCreateSchema =
            switch input.body {
            case .json(let value): value
            }
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeEditArticle()
            .execute(
                subject: subject,
                input: body.editArticleInput(id: input.path.newsArticleId)
            )
        return .ok(.init(body: .json(map(result))))
    }

    public func newsArticleDelete(
        _ input: Operations.NewsArticleDelete.Input
    ) async throws -> Operations.NewsArticleDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema =
            switch input.body {
            case .json(let value): value
            }
        let subject = try await CurrentSubject.require()
        _ = try await useCases.makeRemoveArticle()
            .execute(
                subject: subject,
                input: .init(ids: body.ids)
            )
        return .noContent(.init())
    }
}

extension Components.Schemas.NewsArticleCreateSchema {
    fileprivate func addArticleInput() -> Article.Add.Input {
        .init(
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            categoryIds: Array(categoryIds ?? []),
            metadata: .init(
                slug: metadata.slug,
                template: "news.article",
                publicationDate: metadata.publicationDate.map(
                    Date.init(timeIntervalSince1970:)
                ),
                expirationDate: metadata.expirationDate.map(
                    Date.init(timeIntervalSince1970:)
                ),
                status: WebModule.Metadata.Model.Status(rawValue: metadata.status)
                    ?? .draft,
                title: metadata.title,
                excerpt: metadata.excerpt,
                imageURL: metadata.imageURL,
                canonicalURL: metadata.canonicalURL,
                noIndex: metadata.noIndex ?? false,
                primaryKeyword: metadata.primaryKeyword ?? "",
                cssCodeInjection: metadata.cssCodeInjection,
                javascriptCodeInjection: metadata.javascriptCodeInjection,
                structuredDataCodeInjection: metadata.structuredDataCodeInjection
            )
        )
    }

    fileprivate func editArticleInput(id: String) -> Article.Edit.Input {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: .some(imageAssetId),
            categoryIds: Array(categoryIds ?? []),
            metadata: .init(
                slug: metadata.slug,
                template: "news.article",
                publicationDate: metadata.publicationDate.map(
                    Date.init(timeIntervalSince1970:)
                ),
                expirationDate: metadata.expirationDate.map(
                    Date.init(timeIntervalSince1970:)
                ),
                status: WebModule.Metadata.Model.Status(rawValue: metadata.status)
                    ?? .draft,
                title: metadata.title,
                excerpt: metadata.excerpt,
                imageURL: metadata.imageURL,
                canonicalURL: metadata.canonicalURL,
                noIndex: metadata.noIndex ?? false,
                primaryKeyword: metadata.primaryKeyword ?? "",
                cssCodeInjection: metadata.cssCodeInjection,
                javascriptCodeInjection: metadata.javascriptCodeInjection,
                structuredDataCodeInjection: metadata.structuredDataCodeInjection
            )
        )
    }
}

extension Components.Schemas.NewsArticleQueryItemSearchRequestQuerySchema {
    fileprivate var asResponse:
        Components.Schemas.NewsArticleQueryItemSearchResponseQuerySchema
    {
        .init(
            page: .init(size: page?.size ?? 20, number: page?.number ?? 1),
            sort: sort?
                .map {
                    .init(
                        field: .init(rawValue: $0.field.rawValue) ?? .id,
                        direction: $0.direction
                    )
                },
            filters: .init(search: filters.search)
        )
    }
}

extension AdminAPIGateway {
    fileprivate func map(
        _ item: Article.Add.Output
    ) -> Components.Schemas.NewsArticleDetailSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            content: item.content,
            imageAssetId: item.imageAssetId,
            categoryIds: item.categoryIds,
            metadata: mapMetadata(item.metadata),
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    fileprivate func map(
        _ item: Article.Edit.Output
    ) -> Components.Schemas.NewsArticleDetailSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            content: item.content,
            imageAssetId: item.imageAssetId,
            categoryIds: item.categoryIds,
            metadata: mapMetadata(item.metadata),
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    fileprivate func mapSearch(
        _ item: Article.Search.Output.Item
    ) -> Components.Schemas.NewsArticleQueryItemSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    fileprivate func map(
        _ item: Article.Detail.Output
    ) -> Components.Schemas.NewsArticleDetailSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            content: item.content,
            imageAssetId: item.imageAssetId,
            categoryIds: item.categoryIds,
            metadata: mapMetadata(item.metadata),
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    fileprivate func map(
        _ item: Article.List.Output.Item
    ) -> Components.Schemas.NewsArticleListItemSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    private func mapMetadata(
        _ item: WebModule.Metadata.Snapshot
    ) -> Components.Schemas.NewsMetadataDetailSchema {
        .init(
            id: item.id,
            referenceType: item.referenceType,
            referenceID: item.referenceID,
            slug: item.slug,
            template: item.template,
            publicationDate: item.publicationDate.timeIntervalSince1970,
            expirationDate: item.expirationDate?.timeIntervalSince1970,
            status: item.status.rawValue,
            title: item.title,
            excerpt: item.excerpt,
            imageURL: item.imageURL,
            canonicalURL: item.canonicalURL,
            noIndex: item.noIndex,
            primaryKeyword: item.primaryKeyword,
            cssCodeInjection: item.cssCodeInjection,
            javascriptCodeInjection: item.javascriptCodeInjection,
            structuredDataCodeInjection: item.structuredDataCodeInjection,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

}
