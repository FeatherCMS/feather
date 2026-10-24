public import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherBackend
import FeatherModuleKit

extension AdminAPIGateway {
    public func contactFormSubmissionRemove(
        _ input: Operations.ContactFormSubmissionRemove.Input
    ) async throws -> Operations.ContactFormSubmissionRemove.Output {
        let useCase = self.useCases.makeRemoveContactFormSubmission()
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        _ = try await useCase.execute(
            subject: try await CurrentSubject.require(),
            input: .init(
                formKey: input.path.contactFormKey,
                ids: body.ids
            )
        )
        return .noContent(.init())
    }
}
