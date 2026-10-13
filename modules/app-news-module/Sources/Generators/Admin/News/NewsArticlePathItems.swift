import FeatherOpenAPI

struct NewsArticleCollectionPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { NewsArticleCreateOperation() }
    var delete: OperationRepresentable? { NewsArticleRemoveOperation() }
}

struct NewsArticleListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsArticleListOperation() }
}

struct NewsArticleSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { NewsArticleSearchOperation() }
}

struct NewsArticleIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsArticleGetOperation() }
    var put: OperationRepresentable? { NewsArticleUpdateOperation() }
}
