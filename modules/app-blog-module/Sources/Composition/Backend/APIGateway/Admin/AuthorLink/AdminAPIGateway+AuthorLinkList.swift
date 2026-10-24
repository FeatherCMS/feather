public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func blogAuthorLinkList(
        _ input: Operations.BlogAuthorLinkList.Input
    ) async throws -> Operations.BlogAuthorLinkList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListAuthorLinks()
            .execute(
                subject: subject,
                input: .init(authorId: input.path.blogAuthorId)
            )
        return .ok(.init(body: .json(result.items.map(mapAuthorLinkListItem))))
    }

    private func mapAuthorLinkListItem(
        _ item: AuthorLink.List.Output.Item
    ) -> Components.Schemas.AuthorLinkListItemSchema {
        .init(
            id: item.id,
            menuId: item.authorId,
            label: item.label,
            url: item.url,
            priority: item.priority,
            isBlank: item.isBlank,
            permission: item.permission,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
