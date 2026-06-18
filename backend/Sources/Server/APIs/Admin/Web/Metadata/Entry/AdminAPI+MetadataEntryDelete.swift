import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webMetadataDelete(
        _ input: Operations.WebMetadataDelete.Input
    ) async throws -> Operations.WebMetadataDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.web.makeRemoveMetadata()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.webMetadataId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
