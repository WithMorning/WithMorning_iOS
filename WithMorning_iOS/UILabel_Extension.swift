//
//  UILabel_Extension.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/25/24.
//

import Foundation
import UIKit

extension UILabel {
    
    func addTrailing(
        with trailingText: String,
        moreText: String,
        moreTextFont: UIFont,
        moreTextColor: UIColor
        
    ) {
        let readMoreText: String = trailingText + moreText
        
        guard let text = self.text else { return }
        
        let textWidth = (text as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font ?? .systemFont(ofSize: 12)],
            context: nil).width
        
        if textWidth <= frame.size.width {
            // 텍스트가 라벨 너비를 초과하지 않으면 그대로 표시
            self.text = text
            return
        }
        
        let readMoreWidth = (readMoreText as NSString).boundingRect(
            with: CGSize(width: .greatestFiniteMagnitude, height: frame.size.height),
            options: .usesLineFragmentOrigin,
            attributes: [.font: moreTextFont],
            context: nil).width
        
        let lineWidth = frame.size.width
        var currentWidth: CGFloat = 0
        var truncatedText = ""
        
        for character in text {
            let charWidth = String(character).size(withAttributes: [.font: font ?? .systemFont(ofSize: 12)]).width
            if currentWidth + charWidth > lineWidth - readMoreWidth {
                break
            }
            truncatedText.append(character)
            currentWidth += charWidth
        }
        
        let attributedString = NSMutableAttributedString(string: truncatedText + trailingText)
        attributedString.addAttribute(.font, value: font ?? .systemFont(ofSize: 12), range: NSRange(location: 0, length: truncatedText.count))
        
        let readMoreAttributedString = NSAttributedString(
            string: moreText,
            attributes: [.font: moreTextFont, .foregroundColor: moreTextColor]
        )
        attributedString.append(readMoreAttributedString)
        
        self.attributedText = attributedString
    }
    
    func truncateText(_ text: String, width: CGFloat, font: UIFont) -> String {
        let attributedText = NSAttributedString(string: text, attributes: [.font: font])
        let textStorage = NSTextStorage(attributedString: attributedText)
        let textContainer = NSTextContainer(size: CGSize(width: width, height: .greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let truncatedGlyphRange = NSRange(location: 0, length: min(glyphRange.length, layoutManager.numberOfGlyphs))
        let truncatedCharacterRange = layoutManager.characterRange(forGlyphRange: truncatedGlyphRange, actualGlyphRange: nil)
        
        return (text as NSString).substring(with: truncatedCharacterRange)
    }
    
    var visibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes)
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}

//MARK: - 글자 행간 조절
extension UILabel{
    func applyDesignFont(_ font: DesignSystemFont, text: String, color: UIColor = .black) {
        self.attributedText = font.attributedString(for: text, color: color)
    }
}
