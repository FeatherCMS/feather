import ContactAdminAPI
import ContactApplication
import ContactDomain
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {
    public func contactFieldUpdate(
        _ input: Operations.ContactFieldUpdate.Input
    ) async throws -> Operations.ContactFieldUpdate.Output {
        let body: Components.Schemas.FormFieldPatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let result = try await self.useCases.makeUpdateFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        id: input.path.formFieldId,
                        formId: nil,
                        key: body.key,
                        type: body._type.flatMap(
                            FormField.ItemType.init(rawValue:)
                        ),
                        label: body.label,
                        allowedValues: body.allowedValues.map {
                            $0.map { .init(value: $0, label: $0) }
                        },
                        isRequired: body.isRequired,
                        position: body.position
                    )
            )
        return .ok(.init(body: .json(map(result))))
    }
}
