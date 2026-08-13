import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension BlogBackend {

    public func blogAuthorLinkCreate(
        _ input: Operations.BlogAuthorLinkCreate.Input
    ) async throws -> Operations.BlogAuthorLinkCreate.Output {
        let body: Components.Schemas.BlogAuthorLinkCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeAddAuthorLink()
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

        return .created(.init(body: .json(map(result))))
    }
}
