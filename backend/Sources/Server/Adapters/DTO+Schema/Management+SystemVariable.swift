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
//extension SystemVariable {
//
//    var schema: Components.Schemas.SystemVariableDetailSchema {
//        .init(
//            id: id,
//            name: name,
//            value: value,
//            notes: notes
//        )
//    }
//
//    var listSchema: Components.Schemas.SystemVariableListItemSchema {
//        .init(
//            id: id,
//            name: name,
//            value: value
//        )
//    }
//
//    init(
//        schema: Components.Schemas.SystemVariableListItemSchema
//    ) {
//        self.init(
//            id: schema.id,
//            name: schema.name,
//            value: schema.value,
//            notes: "",
//            createdAt: 0
//        )
//    }
//}
