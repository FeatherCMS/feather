import FeatherApplication
import FeatherContracts
import FeatherDomain
import MediaAdminAPI
import MediaApplication

extension MediaBackend {
    public func mediaFolderCreate(
        _ input: Operations.MediaFolderCreate.Input
    ) async throws -> Operations.MediaFolderCreate.Output {
        let body: Components.Schemas.MediaFolderCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await self.makeCreateFolder()
            .execute(
                subject: subject,
                input: .init(
                    parentId: (body.parentId ?? "").emptyToNil,
                    name: body.name
                )
            )

        return .created(.init(body: .json(map(result))))
    }
}
