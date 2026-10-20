import FeatherBackend
import FeatherDomain
import FeatherModuleKit
public import UserAdminAPI
import UserApplication

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
            return badRequest()
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
                body: .json(map(result))
            )
        )
    }

    private func badRequest() -> Operations.UserRolePatch.Output {
        .badRequest(
            .init(
                body: .json(
                    .init(
                        error: .init(
                            message: "Bad Request",
                            reason: "Invalid updateMask."
                        )
                    )
                )
            )
        )
    }
}
