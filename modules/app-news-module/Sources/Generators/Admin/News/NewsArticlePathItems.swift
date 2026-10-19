import FeatherOpenAPI

struct NewsArticleCollectionPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { NewsArticleCreateOperation() }
    var delete: (any OperationRepresentable)? { NewsArticleRemoveOperation() }
}

struct NewsArticleListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { NewsArticleListOperation() }
}

struct NewsArticleSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { NewsArticleSearchOperation() }
}

struct NewsArticleIDPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { NewsArticleGetOperation() }
    var put: (any OperationRepresentable)? { NewsArticleUpdateOperation() }
}
