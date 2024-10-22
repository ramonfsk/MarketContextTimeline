//
//  BasicArrangedViews.swift
//  MarketContextTimeline
//
//  Created by Ramon Ferreira on 22/10/24.
//

import UIKit

final class BasicArrangedViews: UIView {
    // MARK: - UIElements
    private lazy var elementsViews: [PaddedLabelView] = []
    
    // MARK: - Properties
    public var titlesOfElements: [String] = [] {
        didSet {
            // remove existing views
            for view in elementsViews { view.removeFromSuperview() }
            
            elementsViews = []
            for title in titlesOfElements {
                let elementView = PaddedLabelView(title: title,
                                                  backgroundColor: elementsBackgroundColor)
                addSubview(elementView)
                elementsViews.append(elementView)
            }
            
            calcFrames(bounds.width)
        }
    }
    
    public lazy var elementsBackgroundColor: UIColor = .systemBlue
    
    // horizontal space between label views
    let internalItemsSpace: CGFloat = 8.0
    
    // vertical space between "rows"
    let lineSpace: CGFloat = 8.0
    
    // we use these to set the intrinsic content size
    private var internalWidth: CGFloat = 0.0
    private var internalHeight: CGFloat = 0.0
    
    private lazy var heightConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: internalWidth, height: internalHeight)
    }
    
    override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        
        // walk-up the view hierarchy...
        // this will handle self-sizing cells in a table or collection view, without
        //  the need to "call back" to the controller
        var sv = superview
        while sv != nil {
            if sv is UITableViewCell || sv is UICollectionViewCell {
                sv?.invalidateIntrinsicContentSize()
                sv = nil
            } else {
                sv = sv?.superview
            }
        }
    }
    
    override var bounds: CGRect {
        willSet {
            if newValue.width != bounds.width {
                calcFrames(newValue.width)
            }
        }
    }
    
    func calcFrames(_ tagetWidth: CGFloat) {
        // this can be called multiple times, and
        //  may be called before we have a frame
        if tagetWidth == 0.0 {
            return
        }
        
        var newWidth: CGFloat = 0.0
        var newHeight: CGFloat = 0.0
        
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        var isMultiLine: Bool = false
        var thisRect: CGRect = .zero
        
        for thisView in elementsViews {
            // start with NOT needing to wrap
            isMultiLine = false
            // set the frame width to a very wide value, so we get the non-wrapped size
            thisView.frame.size.width = .greatestFiniteMagnitude
            thisView.layoutIfNeeded()
            var size: CGSize = thisView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            size.width = ceil(size.width)
            size.height = ceil(size.height)
            thisRect = .init(x: x, y: y, width: size.width, height: size.height)
            // if this item is too wide to fit on the "row"
            if thisRect.maxX > tagetWidth {
                // if this is not the FIRST item on the row
                //  move down a row and reset x
                if x > 0.0 {
                    x = 0.0
                    y = thisRect.maxY + lineSpace
                }
                thisRect = .init(x: x, y: y, width: size.width, height: size.height)
                // if this item is still too wide to fit, that means
                //  it needs to wrap the text
                if thisRect.maxX > tagetWidth {
                    isMultiLine = true
                    // this will give us the height based on max available width
                    size = thisView.systemLayoutSizeFitting(.init(width: tagetWidth, height: .greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
                    size.width = ceil(size.width)
                    size.height = ceil(size.height)
                    // update the frame
                    thisView.frame.size = size
                    thisView.layoutIfNeeded()
                    // this will give us the width needed for the wrapped text (instead of the max available width)
                    size = thisView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    size.width = ceil(size.width)
                    size.height = ceil(size.height)
                    thisRect = .init(x: x, y: y, width: size.width, height: size.height)
                }
            }
            // if we needed to wrap the text, adjust the next Y and reset X
            if isMultiLine {
                x = 0.0
                y = thisRect.maxY + lineSpace
            }
            thisView.frame = thisRect
            // update the max width var
            newWidth = max(newWidth, thisRect.maxX)
            // if we did NOT need to wrap lines, adjust the X
            if !isMultiLine {
                x += size.width + internalItemsSpace
            }
        }
        
        newHeight = thisRect.maxY
        
        if internalWidth != newWidth || internalHeight != newHeight {
            internalWidth = newWidth
            internalHeight = newHeight
            // don't activate the constraint if we're not in an auto-layout case
            if self.translatesAutoresizingMaskIntoConstraints == false {
                heightConstraint.isActive = true
            }
            // update the height constraint constant
            heightConstraint.constant = internalHeight
            invalidateIntrinsicContentSize()
        }
    }
}

extension BasicArrangedViews {
    private func setupConstraints() {
        heightConstraint = heightAnchor.constraint(equalToConstant: 0.0)
        heightConstraint.priority = .required - 1
    }
}
