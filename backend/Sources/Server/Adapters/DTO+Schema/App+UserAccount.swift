//import UserApplication
//import SystemApplication
//import UserDomain
//import SystemDomain
//import UserInfrastructure
//import SystemInfrastructure
//import Domain
//import AppOpenAPI
//
//extension UserAccount {
//
//    var appSchema: Components.Schemas.UserAccountDetailSchema {
//        .init(
//            id: id,
//            email: email
//        )
//    }
//
//    func appMeSchema(
//        roles: [String],
//        permissions: [String]
//    ) -> Components.Schemas.UserAuthMeResponseSchema {
//        .init(
//            user: appSchema,
//            roles: roles,
//            permissions: permissions
//        )
//    }
//}
