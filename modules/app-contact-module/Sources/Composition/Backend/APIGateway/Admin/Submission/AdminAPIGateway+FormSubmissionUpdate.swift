public import ContactAdminAPI
import ContactApplication
import ContactDomain
import ContactModule
import FeatherApplication
import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Foundation
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
                body: .json(
                    .init(
                        id: result.id,
                        formKey: input.path.contactFormKey,
                        values: .init(
                            additionalProperties: jsonProperties(
                                result.valuesJSON
                            )
                        ),
                        itemsSnapshot: .init(
                            additionalProperties: jsonProperties(
                                result.itemsSnapshotJSON
                            )
                        ),
                        metadata: .init(
                            additionalProperties: jsonProperties(
                                result.metadataJSON ?? "{}"
                            )
                        ),
                        status: result.status.rawValue,
                        createdAt: result.createdAt.timeIntervalSince1970,
                        updatedAt: result.updatedAt.timeIntervalSince1970
                    )
                )
            )
        )
    }

    private func jsonProperties(_ value: String) -> [String: String] {
        guard let data = value.data(using: .utf8),
            let object = try? JSONSerialization.jsonObject(with: data),
            let dictionary = object as? [String: Any]
        else { return [:] }
        return dictionary.mapValues { String(describing: $0) }
    }
}
