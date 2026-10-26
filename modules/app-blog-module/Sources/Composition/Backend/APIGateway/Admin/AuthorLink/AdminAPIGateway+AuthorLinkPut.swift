public import BlogAdminAPI
import BlogApplication
import BlogModule
import WebApplication
import FeatherDomain
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func blogAuthorLinkPut(
        _ input: Operations.BlogAuthorLinkPut.Input
    ) async throws -> Operations.BlogAuthorLinkPut.Output {
        let body: Components.Schemas.AuthorLinkPutSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeEditAuthorLink()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorLinkId,
                authorId: input.path.blogAuthorId,
                label: .set(body.label),
                url: .set(body.url),
                priority: .set(body.priority),
                isBlank: .set(body.isBlank),
                permission: .set(body.permission),
                notes: body.notes.map { .set($0) } ?? .unchanged
            )
        )

        return .ok(.init(body: .json(mapEditedAuthorLink(result))))
    }

    private func mapEditedAuthorLink(
        _ detail: AuthorLink.Edit.Output
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
