enum ServerConfigurationError: Error {
    case missing(String)
    case invalidURL(String)
}
