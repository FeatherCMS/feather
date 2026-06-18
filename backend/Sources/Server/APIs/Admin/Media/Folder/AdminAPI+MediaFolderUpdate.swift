import Application
import MediaApplication
import AdminOpenAPI

extension AdminAPI {
    func mediaFolderUpdate(
        _ input: Operations.MediaFolderUpdate.Input
    ) async throws -> Operations.MediaFolderUpdate.Output {
        let body: Components.Schemas.MediaFolderPatchSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        do {
            let result = try await modules.media.makeEditFolder()
                .execute(
                    subject: subject,
                    input: .init(
                        id: input.path.mediaFolderId,
                        name: body.name
                    )
                )
            return .ok(.init(body: .json(map(result))))
        }
        catch let error as EditMediaFolder.Error {
            switch error {
            case .notFound:
                return .notFound(.init())
            case .invalidName:
                throw error
            }
        }
    }
}
