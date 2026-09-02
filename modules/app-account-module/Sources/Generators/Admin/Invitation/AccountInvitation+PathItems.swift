import FeatherOpenAPI

struct AccountInvitationPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AccountInvitationCreateOperation() }
    var delete: OperationRepresentable? {
        AccountInvitationDeleteOperation()
    }
}

struct AccountInvitationSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AccountInvitationSearchOperation() }
}

struct AccountInvitationListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AccountInvitationListOperation() }
}

struct AccountInvitationIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AccountInvitationGetOperation() }
    var put: OperationRepresentable? { AccountInvitationUpdateOperation() }
    var patch: OperationRepresentable? { AccountInvitationPatchOperation() }
}

struct AccountInvitationResendPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AccountInvitationResendOperation() }
}
