import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webMetadataGet(
        _ input: Operations.WebMetadataGet.Input
    ) async throws -> Operations.WebMetadataGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.web.makeGetMetadata()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.webMetadataId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
