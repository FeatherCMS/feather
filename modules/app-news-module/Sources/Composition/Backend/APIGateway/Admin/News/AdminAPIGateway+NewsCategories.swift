import FeatherApplication
import FeatherModuleKit
import Foundation
public import NewsAdminAPI
import NewsApplication
import NewsDomain
import WebApplication

extension AdminAPIGateway {
    public func newsCategoryCreate(
        _ input: Operations.NewsCategoryCreate.Input
    ) async throws -> Operations.NewsCategoryCreate.Output {
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

    public func newsCategorySearch(
        _ input: Operations.NewsCategorySearch.Input
    ) async throws -> Operations.NewsCategorySearch.Output {
        let query:
            Components.Schemas.NewsCategoryListItemSearchRequestQuerySchema =
                switch input.body {
                case .json(let value): value
                }
        let subject = try await CurrentSubject.require()
        let objectQuery = NewsDomain.Category.List.Input.Query(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            search: query.filters.search
        )
        let useCase = useCases.makeListCategories()
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
                        query: query.asResponse,
                        data: .init(items: result.items.map(map), total: total)
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

    public func newsCategoryUpdate(
        _ input: Operations.NewsCategoryUpdate.Input
    ) async throws -> Operations.NewsCategoryUpdate.Output {
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

    public func newsCategoryRemove(
        _ input: Operations.NewsCategoryRemove.Input
    ) async throws -> Operations.NewsCategoryRemove.Output {
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
    fileprivate func addCategoryInput() -> NewsDomain.Category.Add.Input {
        .init(
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            metadata: metadata.pageAddMetadata(template: "news.category")
        )
    }

    fileprivate func editCategoryInput(id: String) -> NewsDomain.Category.Edit.Input {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: .some(imageAssetId),
            metadata: metadata.pageEditMetadata(template: "news.category")
        )
    }
}

extension AdminAPIGateway {
    fileprivate func map(
        _ item: NewsDomain.Category.Detail.Output
    ) -> Components.Schemas.NewsCategoryDetailSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            content: item.content,
            imageAssetId: item.imageAssetId,
            metadata: map(item.metadata),
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    fileprivate func map(
        _ item: NewsDomain.Category.List.Output.Item
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

}

private extension Components.Schemas.NewsCategoryListItemSearchRequestQuerySchema {
    var asResponse: Components.Schemas.NewsCategoryListItemSearchResponseQuerySchema {
        .init(
            page: .init(size: page?.size ?? 20, number: page?.number ?? 1),
            sort: sort?.map {
                .init(
                    field: .init(rawValue: $0.field.rawValue) ?? .id,
                    direction: $0.direction
                )
            },
            filters: .init(search: filters.search)
        )
    }
}
