<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Join</title>
<style>
    table input {
        width: 280px;
        height: 25px;
        margin: 8px;
    }

    .btns {
        height: 40px;
    }

    #btnJoin {
        width: 300px;
    }

    #btnIndex {
        width: 98px;
    }
</style>
</head>
<body>
    <h1>Join</h1>
    <hr>

    <table>
        <tr> </label>
            <td><label for="txtUserId">아이디</label></td>
            <td>
                <input type="text" id="txtUserId" name="userId" placeholder="아이디 입력 (영소문자, 숫자 포함 6~12자)">
                <button type="button" id="btnCheckId">중복확인</button>
            </td>
        </tr>

        <tr>
            <td><label for="txtUserPw">비밀번호</label></td>            
            <td>
                <input type="password" id="txtUserPw" name="userPw" placeholder="비밀번호 입력 (6~20자)"> 
                <span id="isPwCorrect"></span>
            </td>            
        </tr>

        <tr>
            <td><label for="txtCheckPw">비밀번호 확인</label></td>
            <td>
                <input type="password" id="txtCheckPw" placeholder="비밀번호 재입력"> 
                <span id="isPwSame"></span>
            </td>
        </tr>

        <tr>
            <td><label for="txtName">이름</label></td>
            <td><input type="text" id="txtName" name="name" placeholder="이름 입력"></td>
        </tr>
        <tr>
            <td><label for="txtEmail">이메일</label></td>
            <td><input type="email" id="txtEmail" name="email" placeholder="이메일 입력 (ex. id@domain.com)"></td>
        </tr>

        <tr>
            <td><label for="kakaoZip">주소</label></td>
            <td>
                <input type="text" id="kakaoZip" placeholder="우편번호">
                <button type="button" id="kakaoFindZipBtn">우편번호 찾기</button>
            </td>
        </tr>
        <tr>
            <td></td>
            <td><input type="text" id="kakaoAddress" name="address" placeholder="주소"></td>
        </tr>
        <tr>
            <td></td>
            <td><input type="text" id="kakaoDetailAddress" placeholder="상세주소"></td>
        </tr>
        <tr>
            <td></td>
            <td><input type="text" id="kakaoExtraAddress" placeholder="참고항목"></td>
        </tr>
    </table>
    <p>
        <button type="button" id="btnJoin" class="btns">회원가입</button>
        <button type="button" id="btnIndex" class="btns">메인으로</button>
    </p>

    <script src="/JS/jquery-3.7.0.min.js"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <script>
    (()=>{   

        const txtUserId   = document.querySelector('#txtUserId');   // 아이디 입력
        const txtUserPw   = document.querySelector('#txtUserPw');   // 비밀번호 입력
        const txtName     = document.querySelector('#txtName');     // 이름 입력
        const txtEmail    = document.querySelector('#txtEmail');    // 이메일 입력
        
        const txtCheckPw  = document.querySelector('#txtCheckPw');  // 비밀번호 확인
        const btnCheckId  = document.querySelector('#btnCheckId');  // 아이디 중복확인 버튼
        const isPwCorrect = document.querySelector('#isPwCorrect'); // 비밀번호 글자수 확인 메세지
        const isPwSame    = document.querySelector('#isPwSame');    // 비밀번호 일치여부 확인 메세지
        
        const btnJoin     = document.querySelector('#btnJoin');     // 회원가입 버튼
        const btnIndex    = document.querySelector('#btnIndex');    // 메인으로 버튼
        
        // 카카오 주소 API 관련
        const kakaoZip           = document.querySelector('#kakaoZip');           // 우편번호
        const kakaoAddress       = document.querySelector('#kakaoAddress');       // 주소
        const kakaoDetailAddress = document.querySelector('#kakaoDetailAddress'); // 상세주소
        const kakaoExtraAddress  = document.querySelector('#kakaoExtraAddress');  // 참고항목
        const kakaoFindZipBtn    = document.querySelector('#kakaoFindZipBtn');    // 우편번호 찾기 버튼
        let finalAddress = ''; // 카카오에서 가져온 주소 문자열을 한 필드에 최종저장
        
        let idChecking = false; // 중복확인을 통과하면 true로 변경된다.
        let checkedId  = '';    // 중복확인이 통과된 아이디가 저장된다.




        ////// 함수부 //////////////////////////////////////////////////////////////////

        const checkJoinData = function() {

            // 1. 아무 양식도 작성하지 않은 경우
            if ((txtUserId.value.length === 0) &&
                (txtUserPw.value.length === 0) &&
                (txtCheckPw.value.length === 0) &&
                (txtName.value.length === 0) &&
                (txtEmail.value.length === 0)) {
                    alert('회원가입 양식을 작성해주세요.')
                    txtUserId.focus();
                    return false;
                }

            // 2.아이디 중복여부 확인
            if ((idChecking == false) || (checkedId != txtUserId.value)) { 
                alert('아이디 중복확인이 필요합니다.');
                txtUserId.value = '';
                txtUserId.focus();
                return false;
            }

            // 3. 비밀번호 검증(정규표현식을 사용하는 것이 더 좋음)
            if (txtUserPw.value.length === 0) {
                alert('비밀번호를 입력해주세요.');
                txtUserPw.value = '';
                txtCheckPw.value = '';
                txtUserPw.focus();
                return false;
            }

            // 4. 비밀번호와 비밀번호 확인 값이 서로 같은지 확인
            if (txtUserPw.value != txtCheckPw.value) {
                alert('입력된 비밀번호가 서로 다릅니다.');
                txtCheckPw.value = '';
                txtCheckPw.focus();
                return false;
            }

            // 5. 이름을 입력했는지 확인
            if (txtName.value.length === 0) {
                alert('이름을 입력해주세요.');
                txtName.focus();
                return false;
            }

            // 6. 이메일을 입력했는지 확인
            if (txtEmail.value.length === 0) {
                alert('이메일을 입력해주세요.');
                txtEmail.focus();
                return false;
            }

            // 7. 이메일의 정규표현식 검증
            let regex = new RegExp(/^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/);
            let testResult = regex.test(txtEmail.value);
            if (testResult === false) {
                // console.log("REGEX FOR EMAIL = " + testResult);
                alert('올바른 이메일 형태를 입력해주세요.');
                txtEmail.focus();
                return false;
            }

            // 8. 위의 검사를 모두 통과했으면 true
            return true;
        }

        // 비밀번호의 글자수와 일치여부 확인
        const checkPw = function() {
            // 비밀번호 글자수 확인
            if (txtUserPw.value != '') {
                if ((txtUserPw.value.length < 6) || (txtUserPw.value.length > 16)) {
                    isPwCorrect.innerHTML = '비밀번호는 6~16자만 가능합니다.';
                    isPwCorrect.style.color = 'red';
                }
                else {
                    isPwCorrect.innerHTML = '사용 가능한 비밀번호입니다.';
                    isPwCorrect.style.color = 'green';
            
                    // 비밀번호 일치여부 확인
                    if ((txtUserPw.value != '') && (txtCheckPw.value != '')) {
                        isPwCorrect.innerHTML = '';
                        if (txtUserPw.value == txtCheckPw.value) {        
                            isPwSame.innerHTML = '비밀번호가 일치합니다.';
                            isPwSame.style.color = 'green';
                        }
                        else {
                            isPwSame.innerHTML = '비밀번호가 일치하지 않습니다.';
                            isPwSame.style.color = 'red';
                        }
                    }
                }
            }
            else {
                isPwCorrect.innerHTML = '';
            }
        }

        // 카카오 주소 API
        const getFinalAddress = function() {
            new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을 때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                let addr = ''; // 주소 변수
                let extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R') {
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // (추가) 조합된 참고항목을 해당 필드에 넣는다.
                    kakaoExtraAddress.value = extraAddr;                
                } else {
                    kakaoExtraAddress.value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                kakaoZip.value = data.zonecode;
                kakaoAddress.value = addr;

                // (custom) 모든 주소를 한 필드에 넣는다.
                finalAddress = kakaoZip.value + " " + kakaoAddress.value + " " + kakaoDetailAddress.value;

                // 커서를 상세주소 필드로 이동한다.
                kakaoDetailAddress.focus();
                }
            }).open();
        }

        // 회원가입 실패 시 입력된 값 리셋
        const resetPage = function() {
            txtUserId = '';
            txtUserPw = '';
            txtCheckPw = '';
            txtName = '';
            txtEmail = '';

            idChecking = false;
            checkedId = '';
            txtUserId.focus();
        }



        ////// 이벤트 핸들러 ///////////////////////////////////////////////////////////

        // 아이디 검증: 빈 값, 범위 외의 값, 중복 값
        btnCheckId.addEventListener('click', ()=>{

            // 1. 값이 비어 있는 경우
            if (txtUserId.value.length === 0) {
                alert('아이디를 입력해주세요.');
                idChecking = false;
                txtUserId.focus();
                return;
            }

            // 2. 값이 범위를 넘는 경우
            if ((txtUserId.value.length < 6) || (txtUserId.value.length > 12)) {
                alert('아이디 길이는 6~12자만 가능합니다.');
                idChecking = false;
                txtUserId.focus();
                return;
            }

            // 3. 허용되지 않은 값이 있는 경우: 특수문자, 영대문자, 공백
            let regex = new RegExp(/^[a-z0-9]+$/);
            let testResult = regex.test(txtUserId.value);
            if (testResult == false) {
                alert('아이디는 영소문자와 숫자만 사용할 수 있습니다.');
                idChecking = false;
                txtUserId.focus();
                return;
            }

            // 4. 
            let requestData = {
                userId : txtUserId.value
            }
            // console.log(requestData);

            //
            let xhr = new XMLHttpRequest(); // 서버와 통신을 수행하는 객체
            xhr.open('POST', '/checkId', true);
            xhr.setRequestHeader('Content-Type', 'application/json'); // 컨텐트타입을 json으로 설정

            xhr.onreadystatechange = function() {
                // 서버와 통신하는 객체의 상태가 변하였다. (즉 서버에서 새로운 데이터가 왔다는 의미)
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        let data = xhr.responseText;
                        if (data == 'FAIL') {
                            alert('이미 존재하는 아이디입니다.');
                            idChecking = false;
                            txtUserId.value = '';
                            txtUserId.focus();
                        }
                        else {
                            alert('사용 가능한 아이디입니다.');
                            idChecking = true;
                            checkedId = txtUserId.value;
                            txtUserPw.focus();
                        }
                    }
                    else {
                        console.error('Request failed with status: ', xhr.status);
                    }
                }
            };

            let dat = JSON.stringify(requestData);
            console.log(dat);
            xhr.send(dat);

            // $.ajax({
            //     url : '/checkId',
            //     type : 'POST',
            //     data : requestData,
            //     success : function(data) {
            //         // 5. 결과를 받는다.
            //         if (data === "OK") {
            //             alert('사용 가능한 아이디입니다.');
            //             checkedId = txtUserId.value;
            //             idChecking = true;
            //             txtUserPw.focus();
            //         }
            //         else {
            //             alert('이미 존재하는 아이디입니다.');
            //             idChecking = false;
            //             txtUserId.value = '';
            //             txtUserId.focus();
            //         }   
            //     }
            // });        
        });

        // 회원가입 버튼
        btnJoin.addEventListener('click', ()=>{

            // 데이터를 검사한다.
            if (false === checkJoinData()) {
                // alert('error');
                return;
            }

            // 가입을 위한 요청 데이터
            let requestData = {
                userId : txtUserId.value, 
                userPw : txtUserPw.value,
                name : txtName.value,
                email : txtEmail.value,
                address : finalAddress
            };
            console.log(requestData); // 꼭 확인해보자.

            $.ajax({
                url : '/join',
                type : 'POST',
                data : requestData,
                success : function(data) {
                    if (data === "OK") {
                        alert('정상적으로 가입되었어요!');
                        location.href = "/login";
                    }
                    else {
                        alert('회원가입에 실패했어요.');
                        resetPage();
                    }
                }
            });
        });

        // 비밀번호의 유효성을 클라이언트가 직접 확인할 수 있도록 메세징
        txtUserPw.addEventListener('input', checkPw);
        txtCheckPw.addEventListener('input', checkPw);
        
        // 카카오 우편번호 찾기 버튼
        kakaoFindZipBtn.addEventListener('click', ()=>{
            getFinalAddress();
        });

        // 메인으로 돌아가는 버튼
        btnIndex.addEventListener('click', ()=>{
            location.href = '/index';
        });
            
    })(); 
    </script>        
</body>