<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Find Password</title>
</head>
<body>
    <h1>Find Password</h1>
    <hr>
    <p>
        <label for="txtUserId">아이디</label>
        <input type="txt" name="userId" id="txtUserId">
        <button type="button" id="btnSubmit">확인</button>        
    </p>
    <p>
        <button type="button" id="btnLogin">로그인</button>
        <button type="button" id="btnIndex">첫화면</button>
    </p>

    <script src="/JS/jquery-3.7.0.min.js"></script>

    <script>
    (()=>{

        const txtUserId  = document.querySelector('#txtUserId');
        const btnSubmit  = document.querySelector('#btnSubmit');
        const btnLogin   = document.querySelector('#btnLogin');
        const btnIndex   = document.querySelector('#btnIndex');

        btnSubmit.addEventListener('click', ()=>{

            // 값을 입력하지 않고 버튼을 클릭하는 경우
            if (txtUserId.value.length === 0) {
                alert('아이디를 입력해주세요.');
                txtUserId.focus();
                return;
            }

            // DB로 전송할 데이터
            let requestData = {
                userId : txtUserId.value
            }
            console.log(requestData);

            // DB와 통신하기
            $.ajax({
                url : '/pwinquiry',
                type : 'POST',
                data : requestData,             // 아이디를 보냈으니
                success : function(data) {      // 비밀번호를 주겠지
                    if (data === "$FAIL") {
                        alert('등록된 아이디가 아닙니다.');
                    }
                    else { // "$OK"
                        alert('비밀번호를 메일로 전송하였습니다.');                    
                    }
                }
            });

        });

        btnLogin.addEventListener('click', ()=>{
            location.href = '/login';
        });

        btnIndex.addEventListener('click', ()=>{
            location.href = '/index';
        });
        
    })();
    </script>
</body>
</html>