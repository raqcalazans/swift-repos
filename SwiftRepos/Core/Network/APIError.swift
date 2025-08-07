import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case decodingError(Error)
    case unexpectedStatusCode(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return String.LocalizedKeys.errorInvalidURL
        case .requestFailed(let error):
            return String.LocalizedKeys.errorRequestFailed(description: error.localizedDescription)
        case .decodingError:
            return String.LocalizedKeys.errorDecoding
        case .unexpectedStatusCode(let statusCode):
            return String.LocalizedKeys.errorUnexpectedStatus(code: statusCode)
        }
    }
}
