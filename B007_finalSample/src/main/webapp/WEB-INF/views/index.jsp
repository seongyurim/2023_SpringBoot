<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main BBS</title>
</head>
<body>
    <h1>Main BBS</h1>
    <!-- <h1>${vo.userId}</h1>
    <h1>${vo.userPw}</h1>
    <h1>${vo.name}</h1>
    <h1>${vo.email}</h1> -->
    <hr>
    <div>
        <p><span id="spnWelcome"></span></p>
        <p>
            <button type="button" id="btnLogin">로그인</button>
            <button type="button" id="btnJoin">회원가입</button>
        </p>        
    </div>

    <table border="1" id="tblBBS">
        <thead>
            <th>순번</th>
            <th>제목</th>
            <th>아이디</th>
            <th>날짜</th>
        </thead>
        <tbody>            
        </tbody>
    </table>
    <p>
        <button type="button" id="btnPrev">이전</button>
        <button type="button" id="btn1" class="btns">1</button>
        <button type="button" id="btn2" class="btns">2</button>
        <button type="button" id="btn3" class="btns">3</button>
        <button type="button" id="btn4" class="btns">4</button>
        <button type="button" id="btn5" class="btns">5</button>
        <button type="button" id="btnNext">다음</button>
        <button type="button" id="btnWrite">글쓰기</button>
    </p>

    <script src="/JS/jquery-3.7.0.min.js"></script>
    
    <script>
    (()=>{

        let sessionState = false;

        // row..
        let rowCount = 0;        // 전체 건수

        // page..
        let rowsPerPage = 5;     // 페이지 당 건수(테이블에서 보여지는 최대 건수)
        let curPage = 0;         // 현재 페이지 위치

        // section..
        let curSection = 0;      // 현재 섹션
        let pagesPerSection = 5; // 섹션당 페이지 수(버튼 수와 동일)

        const spnWelcome = document.querySelector('#spnWelcome');
        const btnLogin   = document.querySelector('#btnLogin');
        const btnJoin    = document.querySelector('#btnJoin');
        const btnPrev    = document.querySelector('#btnPrev');
        const btnNext    = document.querySelector('#btnNext');
        const btnWrite   = document.querySelector('#btnWrite');
        const btn1 = document.querySelector('#btn1');
        const btn2 = document.querySelector('#btn2');
        const btn3 = document.querySelector('#btn3');
        const btn4 = document.querySelector('#btn4');
        const btn5 = document.querySelector('#btn5');

        ////// 함수부 //////////////////////////////////////////////////////////////////
        // 현재 세션이 있는지 없는지 설정해준다.
        const setSessionState = function() {
            if ('${vo.userId}' == '') {
                sessionState = false;
            }
            else {
                sessionState = true;
            }
        }

        
        // 메인 화면의 웰컴 메세지를 설정한다.
        const setWelcomeMsg = function() {
            if (sessionState === true) {
                spnWelcome.textContent = '${vo.name}님 반갑습니다ヽ( ´ー`)ノ';
            }
            else {
                spnWelcome.textContent = '로그인이 필요한 서비스입니다.';
            }
        }

        // 로그인 여부에 따라 버튼을 다르게 설정한다.
        const setLoginButton = function() {
            if (sessionState === true) {
                btnLogin.textContent = '로그아웃';
            }
            else {
                btnLogin.textContent = '로그인';
            }
        }

        const setJoinButton = function() {
            if (sessionState === true) {
                btnJoin.style.display = 'none';
            }
        }


        // 게시판을 세팅한다.
        const setBBS = function(page) {
            // BBS 세팅을 위한 데이터를 오브젝트에 담기
            let requestData = {
                // divi : 'C',
                page : page,
                rowsPerPage : rowsPerPage // 현재 전역변수에 5로 설정되어 있음
            };

            // 오브젝트를 DB로 전달하기
            $.ajax({
                url : 'bbs/list',
                type : 'POST',
                data : requestData,
                success : function(data) { // 여기서 받는 데이터: rowCount, bbsList
                    
                    let bstr = '';
                    const tblBody = document.querySelector('#tblBBS > tbody')

                    // 전체 카운트를 저장한다.
                    rowCount = data.rowCount;

                    // 테이블 body를 채워준다.
                    tblBody.innerHTML = '';

                    for (let i = 0; i < data.bbsList.length; i++) {
                        bstr = '';
                        bstr += '<tr>';
                            bstr += '<td>' + data.bbsList[i].rowNum + '</td>';
                            // bstr += '<td>' + data.bbsList[i].title + '</td>';
                            
                            bstr += '<td><a href=\"/bbs/content?userId=' + data.bbsList[i].userId
                                          + '&seq=' + data.bbsList[i].seq
                                          + '\">' + data.bbsList[i].title
                                          + '</a></td>';

                            bstr += '<td>' + data.bbsList[i].userId + '</td>';
                            bstr += '<td>' + data.bbsList[i].regdate + '</td>';
                        bstr += '</tr>';

                    tblBody.innerHTML += bstr;
                    }
                }
            });
            // console.log(requestData);
        }


        // 실제 적용해야 할 페이지를 구한다.
        const getRealPage = function(pageOffset) {
            return (curSection * pagesPerSection) + pageOffset;
        }

        // 게시판 버튼 숫자를 업데이트하고 남는 버튼은 삭제한다.
        const updateBtns = function() {
            let startPage = curSection * pagesPerSection + 1;
            for (let i = 0; i < pagesPerSection; i++) {
                const btn = document.querySelector('#btn' + (i+1));
                if (startPage <= Math.ceil(rowCount / rowsPerPage)) {
                    btn.textContent = startPage++;
                    btn.style.display = 'inline';
                }
                else {
                    btn.style.display = 'none';
                }
            }
        }



        ////// 이벤트 핸들러 ///////////////////////////////////////////////////////////
        
        // 로그인 버튼
        btnLogin.addEventListener('click', ()=>{
            if (sessionState === true) { // 로그인한 상태라면
                if (!confirm("정말 로그아웃 하시겠어요?")) {
                    return;
                }
                else {
                    alert('정상적으로 로그아웃 되었어요.');
                    location.href = '/logout';
                }
            }
            else { // 로그인한 상태가 아니라면
                location.href = '/login';
            }
        });

        btnJoin.addEventListener('click', ()=>{
            location.href = '/join';
        });

        // 이전 목록 버튼
        btnPrev.addEventListener('click', ()=> {
            
            if (curSection <= 0) {
                alert("첫 페이지입니다.");
                return;
            }

            curSection--;
            updateBtns();
            let realPage = getRealPage(0); // 이전 페이지의 0번으로 설정
            setBBS(realPage);
        });
        

        // 다음 목록 버튼
        btnNext.addEventListener('click', ()=> {
            
            let rowsPerSection = rowsPerPage * pagesPerSection; // 25개            
            let nextRowCount = rowCount - rowsPerSection * (curSection + 1);
            
            if (nextRowCount <= 0) {
                alert("마지막 페이지입니다.");
                return;
            }

            curSection++;
            updateBtns();
            let realPage = getRealPage(0); // 다음 페이지의 0번으로 설정
            setBBS(realPage);
            console.log("curSection = " + curSection);            
        });

        btn1.addEventListener('click', ()=> {
            // 1번 버튼을 눌렀을 때
            const offset = 0; // 0번 버튼을 누른 것이므로
            const realPage = getRealPage(offset); // offset, curSection 값을 이용해서
            setBBS(realPage);
            console.log("realPage = " + realPage);
        });

        btn2.addEventListener('click', ()=> {
            // 2번 버튼을 눌렀을 때
            const offset = 1; // 1번 버튼을 누른 것이므로
            const realPage = getRealPage(offset);
            setBBS(realPage);
            console.log("realPage = " + realPage);
        });

        btn3.addEventListener('click', ()=> {
            // 3번 버튼을 눌렀을 때
            const offset = 2; // 2번 버튼을 누른 것이므로
            const realPage = getRealPage(offset);
            setBBS(realPage);
            console.log("realPage = " + realPage);
        });

        btn4.addEventListener('click', ()=> {
            // 4번 버튼을 눌렀을 때
            const offset = 3; // 3번 버튼을 누른 것이므로
            const realPage = getRealPage(offset);
            setBBS(realPage);
            console.log("realPage = " + realPage);
        });

        btn5.addEventListener('click', ()=> {
            // 5번 버튼을 눌렀을 때
            const offset = 4; // 4번 버튼을 누른 것이므로
            const realPage = getRealPage(offset);
            setBBS(realPage);
            console.log("realPage = " + realPage);
        });

        // 글쓰기 버튼
        btnWrite.addEventListener('click', ()=>{

            // 비로그인 상태
            if (sessionState === false) {
                alert('로그인이 필요해요.');
                return;
            }
            // 로그인 상태
            else {
                location.href = "/bbs/newcontent";
            }
        });




        ////// 호출부 //////////////////////////////////////////////////////////////////
        setSessionState(); // 세션이 있는지 없는지 상태값을 저장한다.
        setWelcomeMsg();   // 로그인한 사용자에게 웰컴 메세지를 설정한다.
        setLoginButton();  // 로그인 여부에 따라 버튼을 로그인/로그오프로 설정한다.
        setJoinButton();   // 로그인이 되었다면 회원가입 버튼을 숨긴다.

        // curPage = 0;
        setBBS(0);

    })();
    </script>
</body>
</html>