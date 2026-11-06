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
            throw HTTPError(.badRequest)
        }

        let name = try FieldChange(
            value: body.name,
            shouldApply: fields.contains(.name),
            onMissing: { HTTPError(.badRequest) }
        )
        let roleIds = try FieldChange(
            value: body.roleIds,
            shouldApply: fields.contains(.roleIds),
            onMissing: { HTTPError(.badRequest) }
        )
        let statusValue = body.status.flatMap {
            Identity.Model.Status(rawValue: $0.rawValue)
        }
        let status: FieldChange<Identity.Model.Status>
        if fields.contains(.status) {
            guard let statusValue else { throw HTTPError(.badRequest) }
            status = .set(statusValue)
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
                body: .json(identityDetailSchema(from: result))
            )
        )
    }

}

private func identityDetailSchema(
    from output: Identity.Edit.Output
) -> Components.Schemas.UserIdentityDetailSchema {
    .init(
        id: output.id,
        name: output.name,
        status: .init(rawValue: output.status.rawValue)!,
        roleIds: output.roleIds
    )
}
