<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
</head>
<body>
    <h1>Login</h1>
    
    <form action="/login" method="post" id="frmLogin">
        <table>
            <tr>
                <td><label for="userId">아이디</label></td>
                <td><input type="text" name="userId" id="userId"></td>
            </tr>
            <tr>
                <td><label for="userPw">비밀번호</label></td>
                <td><input type="text" name="userPw" id="userPw"></td>
            </tr>
        </table>
    </form>

    <p>
        <div>
            <button type="button" id="btnLogin">로그인</button>
            <button type="button" id="btnIndex">첫화면</button>
        </div>
        <hr>
        <div>
            <button type="button" id="btnJoin">회원가입</button>
            <button type="button" id="btnFindId">아이디찾기</button>
            <button type="button" id="btnFindPw">비밀번호찾기</button>
        </div>
    </p>

    <script>
    (()=>{
        
        const btnLogin  = document.querySelector('#btnLogin');
        const btnIndex  = document.querySelector('#btnIndex');
        const btnJoin   = document.querySelector('#btnJoin');
        const btnFindId = document.querySelector('#btnFindId');
        const btnFindPw = document.querySelector('#btnFindPw');
        const userId    = document.querySelector('#userId');
        const userPw    = document.querySelector('#userPw');
        
        btnLogin.addEventListener('click', ()=>{

            if ((userId.value == "") || (userPw.value == "")) {
                alert('아이디 혹은 비밀번호가 입력되지 않았어요.');
            }

            // form DOM을 가지고 온다.
            const frmLogin = document.querySelector('#frmLogin');

            // form DOM의 submit 함수를 호출한다.
            // action="/login" method="post" 정보를 통해 작동
            frmLogin.submit(); 
        });

        btnIndex.addEventListener('click', ()=>{
            location.href = '/index';
        });

        btnJoin.addEventListener('click', ()=>{
            location.href = '/join';
        });

        btnFindId.addEventListener('click', ()=>{
            location.href = '/idinquiry';
        });

        btnFindPw.addEventListener('click', ()=>{
            location.href = '/pwinquiry';

        });        
    })();
    </script>
</body>
</html>