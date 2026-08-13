//import AccountApplication
//import SystemApplication
//import UserDomain
//import SystemDomain
//import UserInfrastructure
//import SystemInfrastructure
//import FeatherApplication
//import AccountApplication
//import FeatherDomain
//import AccountAdminAPI
//
//extension AccountInvitation {
//
//    var schema: Components.Schemas.AccountInvitationDetailSchema {
//        .init(
//            id: id,
//            email: email,
//            token: token,
//            expiresAt: expiresAt
//        )
//    }
//
//    var listSchema: Components.Schemas.AccountInvitationListItemSchema {
//        .init(
//            id: id,
//            email: email,
//            token: token,
//            expiresAt: expiresAt
//        )
//    }
//
//    init(
//        schema: Components.Schemas.AccountInvitationListItemSchema
//    ) {
//        self.init(
//            id: schema.id,
//            email: schema.email,
//            token: schema.token,
//            expiresAt: schema.expiresAt,
//            createdAt: 0
//        )
//    }
//}
