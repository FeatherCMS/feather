public import ContactAdminAPI
import ContactApplication
import ContactDomain
import ContactModule
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {
    public func contactFieldGet(
        _ input: Operations.ContactFieldGet.Input
    ) async throws -> Operations.ContactFieldGet.Output {
        let result = try await self.useCases.makeDetailFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(id: input.path.formFieldId, formId: nil)
            )
        return .ok(.init(body: .json(map(result))))
    }

    private func map(
        _ value: FormField.Detail.Output
    ) -> Components.Schemas.FormFieldSchema {
        .init(
            id: value.id,
            key: value.key,
            _type: value.type.rawValue,
            label: value.label,
            allowedValues: value.allowedValues.map(\.value),
            isRequired: value.isRequired,
            position: value.position,
            createdAt: value.createdAt.timeIntervalSince1970,
            updatedAt: value.updatedAt.timeIntervalSince1970
        )
    }
}
