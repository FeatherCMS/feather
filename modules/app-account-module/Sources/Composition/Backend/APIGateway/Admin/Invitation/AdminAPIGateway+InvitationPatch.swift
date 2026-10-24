public import AccountAdminAPI
import AccountApplication
import AccountModule
import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case email
        case roleIds
    }

    public func accountInvitationPatch(
        _ input: Operations.AccountInvitationPatch.Input
    ) async throws -> Operations.AccountInvitationPatch.Output {
        let body: Components.Schemas.InvitationPatchSchema
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

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeEditInvitation()
        let result = try await useCase.execute(
            subject: subject,
            input: Invitation.Edit.Input(
                id: input.path.accountInvitationId,
                email: try FieldChange(
                    value: body.email,
                    shouldApply: fields.contains(.email),
                    onMissing: { HTTPError(.badRequest) }
                ),
                roleIDs: try FieldChange(
                    value: body.roleIds,
                    shouldApply: fields.contains(.roleIds),
                    onMissing: { HTTPError(.badRequest) }
                )
            )
        )

        return .ok(
            .init(
                body: .json(invitationDetailSchema(from: result))
            )
        )
    }
}
