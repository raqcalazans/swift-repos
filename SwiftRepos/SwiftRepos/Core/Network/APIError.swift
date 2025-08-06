import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case decodingError(Error)
    case unexpectedStatusCode(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "A URL fornecida é inválida."
        case .requestFailed(let error):
            return "A requisição falhou: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Erro ao decodificar a resposta: \(error.localizedDescription)"
        case .unexpectedStatusCode(let statusCode):
            return "A API retornou um status inesperado: \(statusCode)"
        }
    }
}
