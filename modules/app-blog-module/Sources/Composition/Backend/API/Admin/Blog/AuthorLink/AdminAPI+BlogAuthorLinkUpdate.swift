import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension BlogBackend {

    public func blogAuthorLinkUpdate(
        _ input: Operations.BlogAuthorLinkUpdate.Input
    ) async throws -> Operations.BlogAuthorLinkUpdate.Output {
        let body: Components.Schemas.BlogAuthorLinkCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeEditAuthorLink()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorLinkId,
                authorId: input.path.blogAuthorId,
                label: body.label,
                url: body.url,
                priority: body.priority,
                isBlank: body.isBlank,
                permission: body.permission,
                notes: body.notes
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
