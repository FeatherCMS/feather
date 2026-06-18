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
//extension SystemPermission {
//
//    var schema: Components.Schemas.SystemPermissionDetailSchema {
//        .init(
//            id: id,
//            name: name,
//            notes: notes
//        )
//    }
//
//    var listSchema: Components.Schemas.SystemPermissionListItemSchema {
//        .init(
//            id: id,
//            name: name
//        )
//    }
//
//    init(
//        schema: Components.Schemas.SystemPermissionListItemSchema
//    ) {
//        self.init(
//            id: schema.id,
//            name: schema.name,
//            notes: "",
//            createdAt: 0
//        )
//    }
//}
