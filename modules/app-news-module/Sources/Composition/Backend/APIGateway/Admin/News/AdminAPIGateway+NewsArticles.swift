import FeatherApplication
import FeatherContracts
import Foundation
public import NewsAdminAPI
import NewsApplication
import WebApplication

extension AdminAPIGateway {
    public func newsArticleCreate(
        _ input: Operations.NewsArticleCreate.Input
    ) async throws -> Operations.NewsArticleCreate.Output {
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

    public func newsArticleSearch(
        _ input: Operations.NewsArticleSearch.Input
    ) async throws -> Operations.NewsArticleSearch.Output {
        let query: Components.Schemas.NewsArticleListItemSearchQuerySchema =
            switch input.body {
            case .json(let value): value
            }
        let subject = try await CurrentSubject.require()
        let objectQuery = ArticleList.Query(
            page: .init(size: query.page.size, number: query.page.number),
            search: query.filters.search
        )
        let useCase = useCases.makeListArticles()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(query: objectQuery)
        )
        return .ok(
            .init(
                body: .json(
                    .init(
                        query: query,
                        data: .init(items: result.items.map(map), total: total)
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

    public func newsArticleUpdate(
        _ input: Operations.NewsArticleUpdate.Input
    ) async throws -> Operations.NewsArticleUpdate.Output {
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

    public func newsArticleRemove(
        _ input: Operations.NewsArticleRemove.Input
    ) async throws -> Operations.NewsArticleRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema =
            switch input.body {
            case .json(let value): value
            }
        let subject = try await CurrentSubject.require()
        let removedIDs = try await useCases.makeRemoveArticle()
            .execute(
                subject: subject,
                input: .init(ids: body.ids)
            )
        let removedIDSet = Set(removedIDs)
        let results = body.ids.map { id in
            Components.Schemas.DeleteResultListSchemaPayload(
                id: id,
                status: removedIDSet.contains(id) ? .deleted : .notFound
            )
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: body.results ? results : nil,
                        summary: body.summary
                            ? .init(
                                requested: body.ids.count,
                                deleted: removedIDs.count,
                                omitted: body.ids.count - removedIDs.count
                            )
                            : nil
                    )
                )
            )
        )
    }
}

extension Components.Schemas.NewsArticleCreateSchema {
    fileprivate func addArticleInput() -> AddArticle.Input {
        .init(
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            categoryIds: Array(categoryIds ?? []),
            metadata: metadata.pageMetadata(template: "news.article")
        )
    }

    fileprivate func editArticleInput(id: String) -> EditArticle.Input {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: .some(imageAssetId),
            categoryIds: Array(categoryIds ?? []),
            metadata: metadata.pageMetadata(template: "news.article")
        )
    }
}

extension AdminAPIGateway {
    fileprivate func map(
        _ item: ArticleDetail
    ) -> Components.Schemas.NewsArticleDetailSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            content: item.content,
            imageAssetId: item.imageAssetId,
            categoryIds: item.categoryIds,
            metadata: map(item.metadata),
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    fileprivate func map(
        _ item: ArticleList.Item
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

}
