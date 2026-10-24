public import ContactAdminAPI
import ContactModule
import ContactApplication
import ContactDomain
import FeatherApplication
import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird

extension AdminAPIGateway {
    private enum UpdateMaskFields: String, Sendable {
        case status
    }

    public func contactFormSubmissionUpdate(
        _ input: Operations.ContactFormSubmissionUpdate.Input
    ) async throws -> Operations.ContactFormSubmissionUpdate.Output {
        let body: Components.Schemas.ContactFormSubmissionPatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }
        let status = try FieldChange(
            value: body.status.flatMap(Submission.Model.Status.init(rawValue:)),
            shouldApply: fields.contains(.status),
            onMissing: { HTTPError(.badRequest) }
        )
        let result = try await self.useCases.makeUpdateContactFormSubmission()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        formKey: input.path.contactFormKey,
                        id: input.path.contactFormSubmissionId,
                        status: status
                    )
            )
        return .ok(
            .init(
                body: .json(map(result, formKey: input.path.contactFormKey))
            )
        )
    }
}
