public protocol ContextualQueryExecutor<S>:
    QueryExecutor,
    ContextualExecutor
where C == any QueryContext {}
