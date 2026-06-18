//import UserApplication
//import SystemApplication
//import UserDomain
//import SystemDomain
//import UserInfrastructure
//import SystemInfrastructure
//import Domain
//import AdminOpenAPI
//
//extension UserAccount {
//
//    var schema: Components.Schemas.UserAccountDetailSchema {
//        .init(
//            id: id,
//            email: email
//        )
//    }
//
//    var listSchema: Components.Schemas.UserAccountListItemSchema {
//        .init(
//            id: id,
//            email: email
//        )
//    }
//
//    func meSchema(
//        roles: [String],
//        permissions: [String]
//    ) -> Components.Schemas.UserAuthMeResponseSchema {
//        .init(
//            user: schema,
//            roles: roles,
//            permissions: permissions
//        )
//    }
//}
