import FeatherOpenAPI

struct NewsCategoryCollectionPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { NewsCategoryCreateOperation() }
    var delete: (any OperationRepresentable)? { NewsCategoryRemoveOperation() }
}

struct NewsCategoryListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { NewsCategoryListOperation() }
}

struct NewsCategorySearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { NewsCategorySearchOperation() }
}

struct NewsCategoryIDPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { NewsCategoryGetOperation() }
    var put: (any OperationRepresentable)? { NewsCategoryUpdateOperation() }
}
