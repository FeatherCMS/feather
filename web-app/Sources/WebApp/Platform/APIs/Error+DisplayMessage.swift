extension Error {
    var displayMessage: String {
        if let error = self as? OpenAPIRepositoryError {
            return error.displayMessage
        }
        return String(describing: self)
    }
}
