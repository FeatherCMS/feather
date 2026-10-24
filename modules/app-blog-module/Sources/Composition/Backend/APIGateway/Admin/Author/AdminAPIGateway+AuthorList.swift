public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func blogAuthorList(
        _ input: Operations.BlogAuthorList.Input
    ) async throws -> Operations.BlogAuthorList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListAuthors()
            .execute(
                subject: subject,
                input: .init()
            )
        return .ok(.init(body: .json(result.items.map(mapAuthorListItem))))
    }

    private func mapAuthorListItem(
        _ item: Author.List.Output.Item
    ) -> Components.Schemas.AuthorListItemSchema {
        .init(
            id: item.id,
            name: item.name,
            excerpt: item.excerpt,
            profileImageAssetId: item.profileImageAssetId,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
