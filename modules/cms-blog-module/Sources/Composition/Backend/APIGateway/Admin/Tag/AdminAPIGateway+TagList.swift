public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func blogTagList(
        _ input: Operations.BlogTagList.Input
    ) async throws -> Operations.BlogTagList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListTags()
            .execute(subject: subject, input: .init())
        return .ok(.init(body: .json(result.items.map(mapListItem))))
    }
}

extension AdminAPIGateway {
    private func mapListItem(
        _ item: Tag.List.Output.Item
    ) -> Components.Schemas.TagListItemSchema {
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
