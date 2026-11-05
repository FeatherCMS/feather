enum WorkerConfigurationError: Error {
    case missing(String)
    case invalidURL(String)
}
