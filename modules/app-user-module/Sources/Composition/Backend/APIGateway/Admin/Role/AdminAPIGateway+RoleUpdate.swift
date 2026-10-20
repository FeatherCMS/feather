import FeatherDomain
import FeatherModuleKit
public import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userRoleUpdate(
        _ input: Operations.UserRoleUpdate.Input
    ) async throws -> Operations.UserRoleUpdate.Output {
        let body: Components.Schemas.UserRoleUpdateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeEditRole()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.userRoleId,
                name: body.name.map(OptionalFieldChange.set) ?? .unchanged,
                notes: body.notes.map(OptionalFieldChange.set) ?? .unchanged
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
