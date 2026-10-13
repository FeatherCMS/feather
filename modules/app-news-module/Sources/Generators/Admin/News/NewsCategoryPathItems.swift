import FeatherOpenAPI

struct NewsCategoryCollectionPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { NewsCategoryCreateOperation() }
    var delete: OperationRepresentable? { NewsCategoryRemoveOperation() }
}

struct NewsCategoryListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsCategoryListOperation() }
}

struct NewsCategorySearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { NewsCategorySearchOperation() }
}

struct NewsCategoryIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsCategoryGetOperation() }
    var put: OperationRepresentable? { NewsCategoryUpdateOperation() }
}
