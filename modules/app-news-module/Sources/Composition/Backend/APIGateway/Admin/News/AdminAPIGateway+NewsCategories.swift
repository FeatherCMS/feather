import FeatherApplication
import FeatherModuleKit
import Foundation
public import NewsAdminAPI
import NewsApplication
import NewsDomain
import NewsModule
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {
    public func newsCategoryPost(
        _ input: Operations.NewsCategoryPost.Input
    ) async throws -> Operations.NewsCategoryPost.Output {
        let body: Components.Schemas.NewsCategoryCreateSchema =
            switch input.body {
            case .json(let value): value
            }
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeAddCategory()
            .execute(
                subject: subject,
                input: body.addCategoryInput()
            )
        return .created(.init(body: .json(map(result))))
    }

    public func newsCategoryList(
        _: Operations.NewsCategoryList.Input
    ) async throws -> Operations.NewsCategoryList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListCategories()
            .execute(
                subject: subject,
                input: .init(query: .init())
            )
        return .ok(.init(body: .json(result.items.map(map))))
    }

    public func newsCategoryQuery(
        _ input: Operations.NewsCategoryQuery.Input
    ) async throws -> Operations.NewsCategoryQuery.Output {
        let query:
            Components.Schemas.NewsCategoryQueryItemSearchRequestQuerySchema =
                switch input.body {
                case .json(let value): value
                }
        let subject = try await CurrentSubject.require()
        let objectQuery = NewsModule.Category.Search.Input.Query(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            search: query.filters.search
        )
        let useCase = useCases.makeSearchCategories()
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

    public func newsCategoryGet(
        _ input: Operations.NewsCategoryGet.Input
    ) async throws -> Operations.NewsCategoryGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeGetCategory()
            .execute(
                subject: subject,
                input: .init(id: input.path.newsCategoryId)
            )
        return .ok(.init(body: .json(map(result))))
    }

    public func newsCategoryPut(
        _ input: Operations.NewsCategoryPut.Input
    ) async throws -> Operations.NewsCategoryPut.Output {
        let body: Components.Schemas.NewsCategoryCreateSchema =
            switch input.body {
            case .json(let value): value
            }
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeEditCategory()
            .execute(
                subject: subject,
                input: body.editCategoryInput(id: input.path.newsCategoryId)
            )
        return .ok(.init(body: .json(map(result))))
    }

    public func newsCategoryDelete(
        _ input: Operations.NewsCategoryDelete.Input
    ) async throws -> Operations.NewsCategoryDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema =
            switch input.body {
            case .json(let value): value
            }
        let subject = try await CurrentSubject.require()
        _ = try await useCases.makeRemoveCategory()
            .execute(
                subject: subject,
                input: .init(ids: body.ids)
            )
        return .noContent(.init())
    }
}

extension Components.Schemas.NewsCategoryCreateSchema {
    fileprivate func addCategoryInput() -> NewsModule.Category.Add.Input {
        .init(
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            metadata: .init(
                slug: metadata.slug,
                template: "news.category",
                publicationDate: metadata.publicationDate.map(
                    Date.init(timeIntervalSince1970:)
                ),
                expirationDate: metadata.expirationDate.map(
                    Date.init(timeIntervalSince1970:)
                ),
                status: WebModule.Metadata.Model.Status(
                    rawValue: metadata.status
                )
                    ?? .draft,
                title: metadata.title,
                excerpt: metadata.excerpt,
                imageURL: metadata.imageURL,
                canonicalURL: metadata.canonicalURL,
                noIndex: metadata.noIndex ?? false,
                primaryKeyword: metadata.primaryKeyword ?? "",
                cssCodeInjection: metadata.cssCodeInjection,
                javascriptCodeInjection: metadata.javascriptCodeInjection,
                structuredDataCodeInjection: metadata
                    .structuredDataCodeInjection
            )
        )
    }

    fileprivate func editCategoryInput(id: String)
        -> NewsModule.Category.Edit.Input
    {
        .init(
            id: id,
            title: .set(title),
            excerpt: .set(excerpt),
            content: .set(content),
            imageAssetId: OptionalFieldChange(
                value: imageAssetId,
                shouldApply: true
            ),
            metadata: .set(
                .init(
                    slug: metadata.slug,
                    template: "news.category",
                    publicationDate: metadata.publicationDate.map(
                        Date.init(timeIntervalSince1970:)
                    ),
                    expirationDate: metadata.expirationDate.map(
                        Date.init(timeIntervalSince1970:)
                    ),
                    status: WebModule.Metadata.Model.Status(
                        rawValue: metadata.status
                    )
                        ?? .draft,
                    title: metadata.title,
                    excerpt: metadata.excerpt,
                    imageURL: metadata.imageURL,
                    canonicalURL: metadata.canonicalURL,
                    noIndex: metadata.noIndex ?? false,
                    primaryKeyword: metadata.primaryKeyword ?? "",
                    cssCodeInjection: metadata.cssCodeInjection,
                    javascriptCodeInjection: metadata.javascriptCodeInjection,
                    structuredDataCodeInjection: metadata
                        .structuredDataCodeInjection
                )
            )
        )
    }
}

extension AdminAPIGateway {
    fileprivate func map(
        _ item: NewsModule.Category.Add.Output
    ) -> Components.Schemas.NewsCategoryDetailSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            content: item.content,
            imageAssetId: item.imageAssetId,
            metadata: mapMetadata(item.metadata),
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    fileprivate func map(
        _ item: NewsModule.Category.Edit.Output
    ) -> Components.Schemas.NewsCategoryDetailSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            content: item.content,
            imageAssetId: item.imageAssetId,
            metadata: mapMetadata(item.metadata),
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    fileprivate func mapSearch(
        _ item: NewsModule.Category.Search.Output.Item
    ) -> Components.Schemas.NewsCategoryQueryItemSchema {
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
        _ item: NewsModule.Category.Detail.Output
    ) -> Components.Schemas.NewsCategoryDetailSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            content: item.content,
            imageAssetId: item.imageAssetId,
            metadata: mapMetadata(item.metadata),
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    fileprivate func map(
        _ item: NewsModule.Category.List.Output.Item
    ) -> Components.Schemas.NewsCategoryListItemSchema {
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

extension Components.Schemas.NewsCategoryQueryItemSearchRequestQuerySchema {
    fileprivate var asResponse:
        Components.Schemas.NewsCategoryQueryItemSearchResponseQuerySchema
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
