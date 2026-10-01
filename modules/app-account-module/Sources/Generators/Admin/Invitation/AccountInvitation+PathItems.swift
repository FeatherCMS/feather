import FeatherOpenAPI

struct AccountInvitationPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AccountInvitationCreateOperation() }
    var delete: (any OperationRepresentable)? {
        AccountInvitationRemoveOperation()
    }
}

struct AccountInvitationSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AccountInvitationSearchOperation() }
}

struct AccountInvitationListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AccountInvitationListOperation() }
}

struct AccountInvitationIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AccountInvitationGetOperation() }
    var put: (any OperationRepresentable)? { AccountInvitationUpdateOperation() }
    var patch: (any OperationRepresentable)? { AccountInvitationPatchOperation() }
}

struct AccountInvitationResendPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AccountInvitationResendOperation() }
}
