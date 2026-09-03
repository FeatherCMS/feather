import FeatherApplication
import FeatherContracts
import UserAdminAPI
import UserApplication
import UserDomain

extension AdminAPIGateway {

    public func userIdentityCreate(
        _ input: Operations.UserIdentityCreate.Input
    ) async throws -> Operations.UserIdentityCreate.Output {
        let body: Components.Schemas.UserIdentityCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeAddIdentity()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                name: body.name,
                status: Identity.Status(
                    rawValue: body.status?.rawValue ?? "invited"
                )
                    ?? .invited
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
