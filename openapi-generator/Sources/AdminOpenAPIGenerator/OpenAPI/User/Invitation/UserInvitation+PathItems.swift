import FeatherOpenAPI

struct UserInvitationPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserInvitationCreateOperation() }
    var delete: OperationRepresentable? { UserInvitationBulkDeleteOperation() }
}

struct UserInvitationSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserInvitationSearchOperation() }
}

struct UserInvitationFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserInvitationFiltersOperation() }
}

struct UserInvitationIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserInvitationGetOperation() }
    var put: OperationRepresentable? { UserInvitationUpdateOperation() }
    var patch: OperationRepresentable? { UserInvitationPatchOperation() }
    var delete: OperationRepresentable? { UserInvitationDeleteOperation() }
}
