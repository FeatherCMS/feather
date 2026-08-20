import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {
    public func blogSettingsGet(
        _ input: Operations.BlogSettingsGet.Input
    ) async throws -> Operations.BlogSettingsGet.Output {
        let useCase = self.useCases.makeGetSettings()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init()
        )

        return .ok(.init(body: .json(map(result))))
    }
}
