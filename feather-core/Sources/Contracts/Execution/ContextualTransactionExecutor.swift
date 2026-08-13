public protocol ContextualTransactionExecutor<S>:
    TransactionExecutor,
    ContextualExecutor
where C == any TransactionContext {}
