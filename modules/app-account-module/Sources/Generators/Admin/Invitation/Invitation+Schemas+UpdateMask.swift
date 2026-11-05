import FeatherOpenAPI

extension Invitation.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "InvitationUpdateMask" }
        var example: String? { "email,roleIds" }
    }
}
