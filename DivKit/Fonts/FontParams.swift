import VGSL

public struct FontParams: Hashable {
  let family: String
  let weight: Int
  let size: Int
  let unit: DivSizeUnit
  let featureSettings: String?
}

public protocol FontParamsProvider {
  func resolveFontFamily(_ expressionResolver: ExpressionResolver) -> String?
  func resolveFontWeight(_ expressionResolver: ExpressionResolver) -> DivFontWeight
  func resolveFontWeightValue(_ expressionResolver: ExpressionResolver) -> Int?
  func resolveFontSize(_ resolver: ExpressionResolver) -> Int
  func resolveFontSizeUnit(_ resolver: ExpressionResolver) -> DivSizeUnit
  func resolveFontFeatureSettings(_ resolver: ExpressionResolver) -> String?
}

extension FontParamsProvider {
  public func resolveFontParams(_ expressionResolver: ExpressionResolver) -> FontParams {
    FontParams(
      family: resolveFontFamily(expressionResolver) ?? "",
      weight: resolveFontWeightValue(expressionResolver)
        ?? resolveFontWeight(expressionResolver).toInt(),
      size: resolveFontSize(expressionResolver),
      unit: resolveFontSizeUnit(expressionResolver),
      featureSettings: resolveFontFeatureSettings(expressionResolver)
    )
  }

  public func resolveFontFeatureSettings(_: ExpressionResolver) -> String? {
    nil
  }
}

extension DivBlockModelingContext {
  public func font(_ params: FontParams) -> Font {
    if flagsInfo.fontCacheEnabled {
      fontCache.withLock { fontCache in
        if let cached = fontCache[params] {
          return cached
        }
        let font = makeFont(provider: self.fontProvider, params: params)
        fontCache[params] = font
        return font
      }
    } else {
      makeFont(provider: self.fontProvider, params: params)
    }
  }
}

private func makeFont(provider: DivFontProvider, params: FontParams) -> Font {
  let font = provider.font(
    family: params.family,
    weight: params.weight,
    size: params.unit.makeScaledValue(params.size)
  )
  #if os(iOS)
  if let featureSettings = params.featureSettings {
    return font.withFontFeatureSettings(featureSettings)
  }
  #endif
  return font
}

private var fontCache = AllocatedUnfairLock<[FontParams: Font]>(uncheckedState: [:])
