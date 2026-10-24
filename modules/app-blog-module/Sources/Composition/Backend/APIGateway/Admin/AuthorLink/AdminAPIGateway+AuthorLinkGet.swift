public import BlogAdminAPI
import BlogApplication
import BlogModule
import WebApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func blogAuthorLinkGet(
        _ input: Operations.BlogAuthorLinkGet.Input
    ) async throws -> Operations.BlogAuthorLinkGet.Output {
        let useCase = self.useCases.makeGetAuthorLink()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorLinkId,
                authorId: input.path.blogAuthorId
            )
        )

        return .ok(.init(body: .json(mapAuthorLinkDetail(result))))
    }

    private func mapAuthorLinkDetail(
        _ detail: AuthorLink.Detail.Output
    ) -> Components.Schemas.AuthorLinkGetSchema {
        .init(
            id: detail.id,
            menuId: detail.authorId,
            label: detail.label,
            url: detail.url,
            priority: detail.priority,
            isBlank: detail.isBlank,
            permission: detail.permission,
            notes: detail.notes,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }
}
