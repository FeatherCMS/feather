//import UserApplication
//import SystemApplication
//import UserDomain
//import SystemDomain
//import UserInfrastructure
//import SystemInfrastructure
//import Application
//import UserApplication
//import Domain
//import AdminOpenAPI
//
//extension UserInvitation {
//
//    var schema: Components.Schemas.UserInvitationDetailSchema {
//        .init(
//            id: id,
//            email: email,
//            token: token,
//            expiresAt: expiresAt
//        )
//    }
//
//    var listSchema: Components.Schemas.UserInvitationListItemSchema {
//        .init(
//            id: id,
//            email: email,
//            token: token,
//            expiresAt: expiresAt
//        )
//    }
//
//    init(
//        schema: Components.Schemas.UserInvitationListItemSchema
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
