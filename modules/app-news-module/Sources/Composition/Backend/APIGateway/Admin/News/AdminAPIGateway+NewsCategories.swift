import FeatherApplication
import FeatherContracts
import Foundation
public import NewsAdminAPI
import NewsApplication
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
        let query: Components.Schemas.NewsCategoryListItemSearchQuerySchema =
            switch input.body {
            case .json(let value): value
            }
        let subject = try await CurrentSubject.require()
        let objectQuery = CategoryList.Query(
            page: .init(size: query.page.size, number: query.page.number),
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
                        query: query,
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
        let removedIDs = try await useCases.makeRemoveCategory()
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

extension Components.Schemas.NewsCategoryCreateSchema {
    fileprivate func addCategoryInput() -> AddCategory.Input {
        .init(
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            metadata: metadata.pageMetadata(template: "news.category")
        )
    }

    fileprivate func editCategoryInput(id: String) -> EditCategory.Input {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: .some(imageAssetId),
            metadata: metadata.pageMetadata(template: "news.category")
        )
    }
}

extension AdminAPIGateway {
    fileprivate func map(
        _ item: CategoryDetail
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
        _ item: CategoryList.Item
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
