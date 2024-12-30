//
//  RemovePaddingUILabel.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 12/30/24.
//

import UIKit

class TopAlignedLabel: UILabel {
    private let lineHeight: CGFloat = 17.0
    
    override func drawText(in rect: CGRect) {
        guard let attributedText = self.attributedText?.mutableCopy() as? NSMutableAttributedString else {
            super.drawText(in: rect)
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = textAlignment
        
        if let font = self.font {
            let baselineOffset = (lineHeight - font.lineHeight) / 2
            attributedText.addAttributes([
                .paragraphStyle: paragraphStyle,
                .baselineOffset: baselineOffset
            ], range: NSRange(location: 0, length: attributedText.length))
        }
        
        let size = attributedText.boundingRect(
            with: CGSize(width: rect.width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size
        
        // 실제 라인 수 계산
        let numberOfLines = ceil(size.height / lineHeight)
        let targetLines = numberOfLines > 0 ? numberOfLines : 1
        
        // 새로운 높이 계산
        var newRect = rect
        newRect.size.height = targetLines * lineHeight
        
        // 텍스트 그리기
        attributedText.draw(with: newRect, options: .usesLineFragmentOrigin, context: nil)
    }
    
    override var intrinsicContentSize: CGSize {
        guard let attributedText = self.attributedText else {
            return super.intrinsicContentSize
        }
        
        let size = attributedText.boundingRect(
            with: CGSize(width: bounds.width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size
        
        let numberOfLines = ceil(size.height / lineHeight)
        let targetLines = numberOfLines > 0 ? numberOfLines : 1
        
        return CGSize(width: size.width, height: targetLines * lineHeight)
    }
    
    func applyDesignFont(_ font: UIFont, text: String, color: UIColor) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = textAlignment
        
        let baselineOffset = (lineHeight - font.lineHeight) / 2
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: baselineOffset
        ]
        
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
        self.invalidateIntrinsicContentSize()
    }
    
    func applyMoreTextStyle(mainText: String, mainFont: UIFont, mainColor: UIColor, moreText: String, moreFont: UIFont, moreColor: UIColor) {
        let finalAttributedString = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = textAlignment
        
        // Main text style
        let mainBaselineOffset = (lineHeight - mainFont.lineHeight) / 2
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: mainFont,
            .foregroundColor: mainColor,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: mainBaselineOffset
        ]
        let mainAttributedText = NSAttributedString(string: mainText, attributes: mainAttributes)
        finalAttributedString.append(mainAttributedText)
        
        // More text style
        let moreBaselineOffset = (lineHeight - moreFont.lineHeight) / 2
        let moreAttributes: [NSAttributedString.Key: Any] = [
            .font: moreFont,
            .foregroundColor: moreColor,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: moreBaselineOffset
        ]
        let moreAttributedText = NSAttributedString(string: moreText, attributes: moreAttributes)
        finalAttributedString.append(moreAttributedText)
        
        self.attributedText = finalAttributedString
        self.invalidateIntrinsicContentSize()
    }
}
