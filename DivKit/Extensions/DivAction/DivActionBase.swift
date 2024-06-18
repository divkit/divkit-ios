import Foundation

import CommonCorePublic
import LayoutKit
import Serialization

public protocol DivActionBase: Serializable {
  var downloadCallbacks: DivDownloadCallbacks? { get }
  var payload: [String: Any]? { get }
  var typed: DivActionTyped? { get }
  var url: Expression<URL>? { get }

  func resolveLogId(_ resolver: ExpressionResolver) -> String?
  func resolveLogUrl(_ resolver: ExpressionResolver) -> URL?
  func resolveReferer(_ resolver: ExpressionResolver) -> URL?
  func resolveUrl(_ resolver: ExpressionResolver) -> URL?
}

extension DivActionBase {
  func makeDivActionPayload(
    cardId: DivCardID,
    source: UserInterfaceAction.DivActionSource,
    localValues: [String: AnyHashable] = [:]
  ) -> UserInterfaceAction.Payload {
    // url parameter is used for backward compatibility, it should be removed
    // when all custom div-action handlers will be replaced
    let url: URL? = switch self.url {
    case let .value(value):
      value.adding(cardId: cardId.rawValue)
    case .link, .none:
      nil
    }

    return .divAction(
      params: UserInterfaceAction.DivActionParams(
        action: .object(toDictionary().typedJSON()),
        cardId: cardId.rawValue,
        source: source,
        url: url,
        localValues: localValues
      )
    )
  }
}

extension URL {
  fileprivate func adding(cardId: String?) -> URL {
    guard scheme == "div-action", host == "set_state" else {
      return self
    }
    return URLByAddingGETParameters(
      ["card_id": cardId].compactMapValues { $0 }
    )
  }
}
