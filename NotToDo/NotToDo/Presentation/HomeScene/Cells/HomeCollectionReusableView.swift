//
//  HomeCollectionReusableView.swift
//  NotToDo
//
//  Created by 강윤서 on 2023/01/06.
//

import UIKit

import SnapKit
import Then

final class HomeCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "HomeCollectionReusableView"
    
    // MARK: - UI Components
    
    private lazy var dateFormatter = DateFormatter()
    private var dateLabel = UILabel()
    private let dateView = UIView()
    private var motivationLabel = UILabel()
    private var graphicImageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeCollectionReusableView {
    private func setUI() {
        backgroundColor = .nottodoWhite
        dateFormatter.do {
            $0.locale = Locale(identifier: "ko_KR")
            $0.dateFormat = "YYYY년 M월"
            $0.timeZone = TimeZone(identifier: "KST")
        }
        dateLabel.do {
            $0.textColor = .nottodoBlack
            $0.font = .PretendardBold(size: 18.adjusted)
            $0.text = "2023년 1월"            // dateFormatter로 수정
        }
        dateView.backgroundColor = .yellow_basic
        motivationLabel.do {
            $0.font = .PretendardBold(size: 27.adjusted)
            $0.textColor = .nottodoBlack
            $0.text = ""
            $0.numberOfLines = 0
        }
        graphicImageView.do {
            $0.image = graphicData.shuffled().first
        }
        layer.addBorder([.bottom], color: .nottodoGray2!, width: 0.5)
    }
    
    private func setLayout() {
        addSubviews(dateView, dateLabel, graphicImageView, motivationLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25.adjusted)
            $0.leading.equalToSuperview().inset(27.adjusted)
        }
        
        dateView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.top)
            $0.trailing.equalTo(dateLabel.snp.trailing).offset(4.adjusted)
            $0.leading.equalTo(dateLabel.snp.leading).offset(-4.adjusted)
            $0.bottom.equalTo(dateLabel.snp.bottom).offset(1.adjusted)
        }
        
        motivationLabel.snp.makeConstraints {
            $0.top.equalTo(dateView.snp.bottom).offset(15.adjusted)
            $0.leading.equalToSuperview().inset(20.adjusted)
            $0.width.equalTo(147.adjusted)
        }
        
        graphicImageView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.height.equalTo(180.adjusted)
            $0.width.equalTo(200.adjusted)
            $0.bottom.equalToSuperview().inset(6.adjusted)
        }
    }
    
    func setRandomData() {
        graphicImageView.image = graphicData.shuffled().first
        let randomText = motivationStringData.shuffled().first!
        self.typingAnimation(randomText)
    }
    
    private func typingAnimation(_ target: String) {
        var charIndex = 0.0
        motivationLabel.text = ""
        for letter in target {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex,
                                 repeats: false) { _ in
                self.motivationLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
}
