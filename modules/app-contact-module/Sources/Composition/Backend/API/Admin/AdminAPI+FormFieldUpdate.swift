import ContactAdminAPI
import ContactApplication
import ContactDomain
import FeatherApplication
import FeatherContracts

extension ContactBackend {
    public func formFieldUpdate(
        _ input: Operations.FormFieldUpdate.Input
    ) async throws -> Operations.FormFieldUpdate.Output {
        let body: Components.Schemas.FormFieldPatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let type = body._type.flatMap(FormField.ItemType.init(rawValue:))
        let result = try await self.makeUpdateFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        id: input.path.formFieldId,
                        formId: input.path.contactFormId,
                        key: body.key,
                        type: type,
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
