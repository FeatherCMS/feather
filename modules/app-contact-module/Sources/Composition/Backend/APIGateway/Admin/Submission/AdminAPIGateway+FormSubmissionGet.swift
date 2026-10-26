public import ContactAdminAPI
import ContactApplication
import ContactDomain
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {
    public func contactFormSubmissionGet(
        _ input: Operations.ContactFormSubmissionGet.Input
    ) async throws -> Operations.ContactFormSubmissionGet.Output {
        let result = try await self.useCases.makeDetailSubmission()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(
                    formKey: input.path.contactFormKey,
                    id: input.path.contactFormSubmissionId
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
