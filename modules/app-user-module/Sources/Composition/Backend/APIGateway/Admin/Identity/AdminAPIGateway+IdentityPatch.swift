import FeatherBackend
import FeatherDomain
import FeatherModuleKit
public import UserAdminAPI
import UserApplication
import UserDomain
import UserModule

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case name
        case roleIds
        case status
    }

    public func userIdentityPatch(
        _ input: Operations.UserIdentityPatch.Input
    ) async throws -> Operations.UserIdentityPatch.Output {
        let body: Components.Schemas.UserIdentityPatchSchema
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

        let name: FieldChange<String>
        if fields.contains(.name) {
            guard let value = body.name else { return badRequest() }
            name = .set(value)
        }
        else {
            name = .unchanged
        }

        let roleIds: FieldChange<[String]>
        if fields.contains(.roleIds) {
            guard let value = body.roleIds else { return badRequest() }
            roleIds = .set(value)
        }
        else {
            roleIds = .unchanged
        }
        let statusValue = body.status.flatMap {
            Identity.Model.Status(rawValue: $0.rawValue)
        }
        let status: FieldChange<Identity.Model.Status>
        if fields.contains(.status) {
            guard let value = statusValue else { return badRequest() }
            status = .set(value)
        }
        else {
            status = .unchanged
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeEditIdentity()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.userIdentityId,
                name: name,
                roleIds: roleIds,
                status: status
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }

    private func badRequest() -> Operations.UserIdentityPatch.Output {
        .badRequest(
            .init(
                body: .json(
                    .init(
                        error: .init(
                            message: "Bad Request",
                            reason: "Invalid or incomplete updateMask."
                        )
                    )
                )
            )
        )
    }
}
