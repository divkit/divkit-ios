import CoreGraphics

import BaseUIPublic
import CommonCorePublic
import LayoutKit

extension DivGallery: DivBlockModeling, DivGalleryProtocol {
  public func makeBlock(context: DivBlockModelingContext) throws -> Block {
    try applyBaseProperties(
      to: { try makeBaseBlock(context: context) },
      context: context,
      actionsHolder: nil,
      options: .noPaddings
    )
  }

  private func makeBaseBlock(context: DivBlockModelingContext) throws -> Block {
    let galleryPath = context.parentPath + (id ?? DivGallery.type)
    let expressionResolver = context.expressionResolver
    let galleryContext = context.modifying(parentPath: galleryPath)
    let defaultAlignment = resolveCrossContentAlignment(expressionResolver)
      .blockAlignment
    let itemSpacing = resolveItemSpacing(expressionResolver)

    return try modifyError({ DivBlockModelingError($0.message, path: galleryPath) }) {
      let model = try makeGalleryModel(
        context: galleryContext,
        direction: resolveOrientation(expressionResolver).direction,
        spacing: CGFloat(itemSpacing),
        crossSpacing: CGFloat(resolveCrossSpacing(expressionResolver) ?? itemSpacing),
        defaultAlignment: defaultAlignment,
        scrollMode: resolveScrollMode(expressionResolver).blockScrollMode,
        columnCount: resolveColumnCount(expressionResolver),
        scrollbar: resolveScrollbar(expressionResolver).blockScrollbar
      )
      return try GalleryBlock(
        model: model,
        state: getState(context: galleryContext, itemsCount: model.items.count),
        widthTrait: resolveWidthTrait(context),
        heightTrait: resolveHeightTrait(context)
      )
    }
  }

  private func getState(
    context: DivBlockModelingContext,
    itemsCount: Int
  ) -> GalleryViewState {
    let path = context.parentPath
    let index: CGFloat
    let scrollRange: CGFloat?
    if let state: GalleryViewState = context.blockStateStorage.getState(path) {
      switch state.contentPosition {
      case .offset:
        return state
      case let .paging(savedIndex):
        index = savedIndex
      }
      scrollRange = state.scrollRange
    } else {
      index = CGFloat(resolveDefaultItem(context.expressionResolver))
      if index == 0 {
        let newState = GalleryViewState(contentOffset: 0, itemsCount: itemsCount)
        context.blockStateStorage.setState(path: path, state: newState)
        return newState
      }
      scrollRange = nil
    }

    let newState = GalleryViewState(
      contentPosition: .paging(index: index.clamp(0.0...CGFloat(itemsCount - 1))),
      itemsCount: itemsCount,
      isScrolling: false,
      scrollRange: scrollRange
    )
    context.blockStateStorage.setState(path: path, state: newState)
    return newState
  }
}

extension DivGallery.Orientation {
  fileprivate var direction: GalleryViewModel.Direction {
    switch self {
    case .horizontal:
      .horizontal
    case .vertical:
      .vertical
    }
  }
}

extension DivGallery.ScrollMode {
  fileprivate var blockScrollMode: GalleryViewModel.ScrollMode {
    switch self {
    case .default:
      .default
    case .paging:
      .autoPaging(inertionEnabled: true)
    }
  }
}

extension DivGallery.CrossContentAlignment {
  fileprivate var blockAlignment: Alignment {
    switch self {
    case .start: .leading
    case .center: .center
    case .end: .trailing
    }
  }
}

extension DivGallery.Scrollbar {
  fileprivate var blockScrollbar: GalleryViewModel.Scrollbar {
    switch self {
    case .none:
      .none
    case .auto:
      .auto
    }
  }
}
