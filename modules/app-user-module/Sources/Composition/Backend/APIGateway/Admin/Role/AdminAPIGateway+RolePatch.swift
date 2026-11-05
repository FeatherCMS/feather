import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird
public import UserAdminAPI
import UserApplication
import UserDomain
import UserModule

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case name
        case notes
    }

    public func userRolePatch(
        _ input: Operations.UserRolePatch.Input
    ) async throws -> Operations.UserRolePatch.Output {
        let body: Components.Schemas.UserRolePatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }

        let name = OptionalFieldChange(
            value: body.name,
            shouldApply: fields.contains(.name)
        )
        let notes = OptionalFieldChange(
            value: body.notes,
            shouldApply: fields.contains(.notes)
        )

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeEditRole()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.userRoleId,
                name: name,
                notes: notes
            )
        )

        return .ok(
            .init(
                body: .json(roleDetailSchema(from: result))
            )
        )
    }

}

private func roleDetailSchema(
    from output: Role.Edit.Output
) -> Components.Schemas.UserRoleDetailSchema {
    .init(
        id: output.id,
        key: output.key,
        name: output.name,
        notes: output.notes
    )
}
