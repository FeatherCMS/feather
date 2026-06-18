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
//extension UserMagicLink {
//
//    var schema: Components.Schemas.UserMagicLinkDetailSchema {
//        .init(
//            id: id,
//            email: email,
//            token: token,
//            expiresAt: expiresAt,
//            isPersistent: isPersistent,
//            isUsed: isUsed
//        )
//    }
//
//    var listSchema: Components.Schemas.UserMagicLinkListItemSchema {
//        .init(
//            id: id,
//            email: email,
//            token: token,
//            expiresAt: expiresAt,
//            isPersistent: isPersistent,
//            isUsed: isUsed
//        )
//    }
//
//    init(
//        schema: Components.Schemas.UserMagicLinkListItemSchema
//    ) {
//        self.init(
//            id: schema.id,
//            email: schema.email,
//            token: schema.token,
//            expiresAt: schema.expiresAt,
//            isPersistent: schema.isPersistent,
//            isUsed: schema.isUsed,
//            createdAt: 0
//        )
//    }
//}
