import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension WebBackend {

    public func webMetadataDelete(
        _ input: Operations.WebMetadataDelete.Input
    ) async throws -> Operations.WebMetadataDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = makeRemoveMetadata()
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
