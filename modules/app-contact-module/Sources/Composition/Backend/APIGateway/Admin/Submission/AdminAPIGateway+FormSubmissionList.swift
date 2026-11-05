public import ContactAdminAPI
import ContactApplication
import ContactDomain
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {
    public func contactFormSubmissionList(
        _ input: Operations.ContactFormSubmissionList.Input
    ) async throws -> Operations.ContactFormSubmissionList.Output {
        let result = try await self.useCases.makeListSubmissions()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(formKey: input.path.contactFormKey)
            )
        return .ok(
            .init(
                body: .json(
                    result.items.map {
                        .init(
                            id: $0.id,
                            formKey: input.path.contactFormKey,
                            values: .init(
                                additionalProperties: jsonProperties(
                                    $0.valuesJSON
                                )
                            ),
                            itemsSnapshot: .init(
                                additionalProperties: jsonProperties(
                                    $0.itemsSnapshotJSON
                                )
                            ),
                            metadata: .init(
                                additionalProperties: jsonProperties(
                                    $0.metadataJSON ?? "{}"
                                )
                            ),
                            status: $0.status.rawValue,
                            createdAt: $0.createdAt.timeIntervalSince1970,
                            updatedAt: $0.updatedAt.timeIntervalSince1970
                        )
                    }
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
