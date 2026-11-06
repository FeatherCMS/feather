public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherModuleKit
import Foundation
import WebApplication

extension AdminAPIGateway {

    public func blogAuthorLinkPost(
        _ input: Operations.BlogAuthorLinkPost.Input
    ) async throws -> Operations.BlogAuthorLinkPost.Output {
        let body: Components.Schemas.AuthorLinkPostSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeAddAuthorLink()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                authorId: input.path.blogAuthorId,
                label: body.label,
                url: body.url,
                priority: body.priority,
                isBlank: body.isBlank,
                permission: body.permission,
                notes: body.notes ?? ""
            )
        )

        return .created(.init(body: .json(mapAddedAuthorLink(result))))
    }

    private func mapAddedAuthorLink(
        _ detail: AuthorLink.Add.Output
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
