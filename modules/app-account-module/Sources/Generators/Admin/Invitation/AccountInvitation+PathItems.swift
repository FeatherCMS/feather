import FeatherOpenAPI

struct AccountInvitationPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AccountInvitationCreateOperation() }
    var delete: OperationRepresentable? {
        AccountInvitationBulkDeleteOperation()
    }
}

struct AccountInvitationSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AccountInvitationSearchOperation() }
}

struct AccountInvitationFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AccountInvitationFiltersOperation() }
}

struct AccountInvitationIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AccountInvitationGetOperation() }
    var put: OperationRepresentable? { AccountInvitationUpdateOperation() }
    var patch: OperationRepresentable? { AccountInvitationPatchOperation() }
}

struct AccountInvitationResendPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AccountInvitationResendOperation() }
}
