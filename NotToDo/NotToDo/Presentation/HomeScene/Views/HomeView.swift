//
//  HomeView.swift
//  NotToDo
//
//  Created by 강윤서 on 2023/01/02.
//

import UIKit

import FSCalendar
import SnapKit
import Then

final class HomeView: UIView {
    
    // MARK: - Properties
    
    var missionList: [DailyMission] = DailyMission.DailyMissionModel
    
    // MARK: - UI Components
    
    private(set) lazy var refreshControl = UIRefreshControl()
    private lazy var homeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    var calendar = FSCalendar(frame: .zero)
    let addMissionButton = NotTodoButton(frame: CGRect(), mode: .withImage, text: I18N.addMissoinButton, image: .plus, font: .semiBold, size: 16)
    
    // MARK: - Life Cycle
    
    init(frame: CGRect, motivationText: String = "초기화값입니다.") {
        super.init(frame: frame)
        setUI()
        setLayout()
        register()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView {
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }
    
    private func register() {
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        homeCollectionView.register(HomeCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: HomeCollectionReusableView.identifier)
        homeCollectionView.register(HomeEmptyCollectionViewCell.self,
                                    forCellWithReuseIdentifier: HomeEmptyCollectionViewCell.identifier)
        homeCollectionView.register(HomeCalendarCollectionViewCell.self,
                                    forCellWithReuseIdentifier: HomeCalendarCollectionViewCell.identifier)
        homeCollectionView.register(HomeMissionCollectionViewCell.self,
                                    forCellWithReuseIdentifier: HomeMissionCollectionViewCell.identifier)
    }
    
    private func setUI() {
        backgroundColor = .white
        homeCollectionView.do {
            $0.backgroundColor = .BG
            $0.refreshControl = refreshControl
            $0.refreshControl?.addTarget(self, action: #selector(handleRefreshControl),
                                         for: .valueChanged)
        }
    }
    
    @objc func handleRefreshControl() {
        // 컨텐츠를 업데이트하세요.
        homeCollectionView.reloadData()
        
        // Refresh control을 제거하세요.
        DispatchQueue.main.async {
            self.homeCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func setLayout() {
        addSubviews(homeCollectionView, addMissionButton)
        
        homeCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview().inset(62.adjusted)
        }
        
        addMissionButton.snp.makeConstraints {
            $0.width.equalTo(149.adjusted)
            $0.height.equalTo(46.adjusted)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(9.adjusted)
        }
    }
}

extension HomeView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCalendarCollectionViewCell.identifier, for: indexPath) as? HomeCalendarCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default:
            if missionList.isEmpty {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeEmptyCollectionViewCell.identifier, for: indexPath) as? HomeEmptyCollectionViewCell else { return UICollectionViewCell() }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMissionCollectionViewCell.identifier, for: indexPath) as? HomeMissionCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(missionList[indexPath.row])
                cell.meatballClickedEvent = { result in
                    if result {
                        let actionSheetViewController = ActionSheetViewController()
                        actionSheetViewController.modalPresentationStyle = .overFullScreen
                        actionSheetViewController.modalTransitionStyle = .crossDissolve
                        HomeView.topViewController()?.present(actionSheetViewController, animated: true)
                        
                    }
                    
                }
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return missionList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeCollectionReusableView.identifier,
                for: indexPath
              ) as? HomeCollectionReusableView else { return UICollectionReusableView() }
        header.setRandomData()
        return header
    }
}

extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: Numbers.width, height: 183.adjusted)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = missionList[indexPath.row].actions.count < 2 ? 144.adjusted : 183.adjusted
        switch indexPath.section {
        case 0:
            return CGSize(width: Numbers.width, height: 106.adjusted)
        default:
            if missionList.isEmpty {
                return CGSize(width: Numbers.width, height: (collectionView.frame.height - 105).adjusted)            // 수정 필요
            } else {
                return CGSize(width: Numbers.width, height: cellHeight)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets()
        default:
            return UIEdgeInsets(top: 7.adjusted, left: 0, bottom: 17.adjusted, right: 0)
        }
    }
}
