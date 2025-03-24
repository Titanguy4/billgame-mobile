enum ErrorApi: Error {
    case invalidURL
    case missingToken
    case httpError(statusCode: Int)
    case decodingError
    case unknownError(Error)
}
