import Application
import MediaApplication
import AdminOpenAPI

extension AdminAPI {
    func mediaFolderCreate(
        _ input: Operations.MediaFolderCreate.Input
    ) async throws -> Operations.MediaFolderCreate.Output {
        let body: Components.Schemas.MediaFolderCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await modules.media.makeCreateFolder()
            .execute(
                subject: subject,
                input: .init(
                    parentId: emptyToNil(body.parentId ?? ""),
                    name: body.name
                )
            )

        return .created(.init(body: .json(map(result))))
    }
}
