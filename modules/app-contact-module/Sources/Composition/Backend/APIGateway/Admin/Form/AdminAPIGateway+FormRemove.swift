public import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherBackend
import FeatherModuleKit

extension AdminAPIGateway {
    public func contactFormRemove(
        _ input: Operations.ContactFormRemove.Input
    ) async throws -> Operations.ContactFormRemove.Output {
        let useCase = self.useCases.makeRemoveContactForm()
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        _ = try await useCase.execute(
            subject: try await CurrentSubject.require(),
            input: .init(keys: body.ids)
        )
        return .noContent(.init())
    }
}
