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
//extension UserRole {
//
//    var schema: Components.Schemas.UserRoleDetailSchema {
//        .init(
//            id: id,
//            name: name,
//            notes: notes
//        )
//    }
//
//    var listSchema: Components.Schemas.UserRoleListItemSchema {
//        .init(
//            id: id,
//            name: name
//        )
//    }
//
//    init(
//        schema: Components.Schemas.UserRoleListItemSchema
//    ) {
//        self.init(
//            id: schema.id,
//            name: schema.name,
//            notes: "",
//            createdAt: 0
//        )
//    }
//}
