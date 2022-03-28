//
//  HomeVC.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by 홍희수 on 2022/03/28.
//

import UIKit
import Toast_Swift


class HomeVC: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var searchFilterSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    
    var keyboardDismissTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    //MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HomeVC - viewDidLoad() 호출됨")
        
        // ui 설정
        self.config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("HomeVC - viewDidAppear() 호출됨")
        self.searchBar.becomeFirstResponder() // 포커싱 주기
    }
    
    // 화면이 넘어가기 전에 준비한다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HomeVC - prepare() 호출됨 / segue.identifier : \(segue.identifier)")
        
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            // 다음 화면의 뷰컨트롤러를 가져온다.
            let nextVC = segue.destination as! UserListVC
            
            guard let userInputValue = self.searchBar.text else { return }
            nextVC.vcTitle = userInputValue + " 👩‍💻"
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            // 다음 화면의 뷰컨트롤러를 가져온다.
            let nextVC = segue.destination as! PhotoCollectionVC
            
            guard let userInputValue = self.searchBar.text else { return }
            nextVC.vcTitle = userInputValue + " 👩‍💻"
        default:
            print("default")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeVC - viewWillAppear() 호출됨")
        
        // 키보드 올라가는 이벤트를 받는 처리
        // 키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeVC - viewDidDisappear() 호출됨")
        // 키보드 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - fileprivate methods
    fileprivate func config() {
        // ui 설정
        self.searchButton.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        
        // searchBar delegate 연결
        self.searchBar.delegate = self
        
        //키보드 delegate 연결
        self.keyboardDismissTabGesture.delegate = self
        
        // 제스처 추가하기
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    fileprivate func pushVC() {
        var segueId : String = ""
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            print("사진 화면으로 이동")
            segueId = "goToPhotoCollectionVC"
        case 1:
            print("사용자 화면으로 이동")
            segueId = "goToUserListVC"
        default:
            print("default")
            segueId = "goToPhotoCollectionVC"
        }
        
        // 화면이동
        self.performSegue(withIdentifier: segueId, sender: self)
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification){
        print("HomeVC - keyboardWillShow() 호출돰")
        // 키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("keyboardSize.height: \(keyboardSize.height)")
            print("searchButton.frame.origin.y : \(searchButton.frame.origin.y)")
            
            if(keyboardSize.height < searchButton.frame.origin.y) {
                print("키보드가 버튼을 덮었다.")
                let distance = keyboardSize.height - searchButton.frame.origin.y
                print("이만큼 덮었다. distance : \(distance)")
                self.view.frame.origin.y = distance + searchButton.frame.height
            }
        }
        //self.view.frame.origin.y = -100
    }
    
    @objc func keyboardWillHideHandle() {
        print("HomeVC - keyboardWillHide() 호출돰")
        self.view.frame.origin.y = 0
    }
    
    //MARK: - IBAction methods
    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        print("HomeVC - onSearchButtonClicked() 호출됨 / selectedIndex : \(searchFilterSegment.selectedSegmentIndex)")
        // 화면으로 이동
        pushVC()
    }
    
    @IBAction func searchFilterValueChanged(_ sender: UISegmentedControl) {
        print("HomeVC - searchFilterValueChanged() 호출됨 / index : \(sender.selectedSegmentIndex)")
        
        var searchBarTitle = ""
        
        switch sender.selectedSegmentIndex {
        case 0:
            searchBarTitle = "사진 키워드"
        case 1:
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = "사진 키워드"
        }
        
        self.searchBar.placeholder = searchBarTitle + " 입력"
        
        self.searchBar.becomeFirstResponder() // 포커싱 주기
        //      self.searchBar.resignFirstResponder() // 포커싱 해제
    }
    
    // MARK: - UISearchBar Delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeVC - searchBarSearchButtonClicked()")
        
        guard let userInputString = searchBar.text else { return }
        
        if userInputString.isEmpty {
            self.view.makeToast("📣 검색 키워드를 입력해주세요.", duration: 1.0, position: .center)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC - searchBar textDidChange() searchText : \(searchText)")
        
        // 사용자가 입력한 값이 없을때
        if (searchText.isEmpty) {
            self.searchButton.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                // 포커싱 해제
                searchBar.resignFirstResponder()
            })
        } else {
            self.searchButton.isHidden = false
        }
    }
    
    // 검색창 입력 단어 수 처리
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        print("shouldChangeTextIn : \(inputTextCount)")
        
        if (inputTextCount >= 12) {
            self.view.makeToast("📢 12자 까지만 입력가능합니다.", duration: 1.0, position: .center)
        }
        
        //        if (inputTextCount <= 12) {
        //            return true
        //        } else {
        //            return true
        //        }
        return inputTextCount <= 12
    }
    
    
    //MARK: - UIGestureRecognizer Delegate methods
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("HomeVC 0 gestureRecognizer sholdRecieve() 호출")
        
        // view를 누르면 키보드가 없어짐
        //이때, 세그먼트 필터, 검색창을 누를 때 예외처리
        if (touch.view?.isDescendant(of: searchFilterSegment) == true) {
            print("세그먼트가 터치되었다.")
            return false
        } else if (touch.view?.isDescendant(of: searchBar) == true) {
            print("서치바가 터치되었다.")
            return false
        }
        else {
            view.endEditing(true)
            print("화면이 터치되었다.")
            return true
        }
        
        
    }
}
