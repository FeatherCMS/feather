public import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherBackend
import FeatherModuleKit

extension AdminAPIGateway {
    public func contactFieldRemove(
        _ input: Operations.ContactFieldRemove.Input
    ) async throws -> Operations.ContactFieldRemove.Output {
        let useCase = self.useCases.makeRemoveFormField()
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        _ = try await useCase.execute(
            subject: try await CurrentSubject.require(),
            input: .init(ids: body.ids, formId: nil)
        )
        return .noContent(.init())
    }
}
