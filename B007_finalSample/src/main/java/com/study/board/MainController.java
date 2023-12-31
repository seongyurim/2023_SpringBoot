package com.study.board;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.board.common.GmailSender;
import com.study.board.common.SessionUtil;
import com.study.board.user.UserDAO;
import com.study.board.user.UserTblVO;

@Controller
public class MainController {

    @Autowired // 의존성을 주입시키는 어노테이션
    UserDAO userDAO;
    
    @GetMapping("/index")
    public String index(Model model) throws Exception {
        // 1. 요청한 주체에게 세션(사용자 정보)이 존재하는가?
        UserTblVO userTblVO = (UserTblVO)SessionUtil.getAttribute("USER");

        // 2. 만약에 세션이 존재한다면 Model에 사용자 정보를 저장하여 index.jsp로 전송한다.
        if (userTblVO != null) {
            model.addAttribute("vo", userTblVO);
        }
        return "index";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    // 아이디, 패스워드를 넘겨서 로그인을 실제로 처리해달라는 요청
    @PostMapping("/login")
    public void login(@ModelAttribute("UserTblVO") UserTblVO vo,
                      HttpServletRequest request,
                      HttpServletResponse response) throws Exception {

        // 오라클에 쿼리를 전송해서 결과를 받아와야 한다.
        // 따라서 그 작업을 수행할 DAO가 필요하다.
        UserTblVO resultVO = userDAO.selectOneUser(vo);

        if (resultVO == null) {
            // 등록된 사용자가 아닌 경우
            System.out.println("등록된 사용자가 아닙니다.");
            response.sendRedirect("login");

        } else {
            // 등록되어 있는 사용자인 경우
            System.out.println("사용자입니다.");
            System.out.println(resultVO);
            SessionUtil.set(request, "USER", resultVO);
            response.sendRedirect("index");
        }
    }

    @GetMapping("/logout")
    public void logout(HttpServletRequest request,
                       HttpServletResponse response) throws Exception {
        // 로그아웃으로 왔다는 것은 현재 로그인이 되어있다는 의미
        // 즉 세션에 사용자 정보가 존재한다는 의미이므로 세션을 비워야 한다.
        SessionUtil.remove(request, "USER");
        response.sendRedirect("index"); // 세션이 비워진 채로 index()로 이동
    }

    @GetMapping("/join")
    public String join(@ModelAttribute("UserTblVO") UserTblVO vo,
                       Model model) throws Exception {

            return "join";
    }

    @PostMapping("/checkId")
    @ResponseBody
    public String checkId(@RequestBody UserTblVO vo) throws Exception {
        
        // System.out.println(vo.getUserId());

        UserTblVO resultVO = userDAO.selectOneUser(vo); // userId가 저장되어 있다.

        if (resultVO == null) {
            return "OK";
        }
        else {
            return "FAIL";
        }
    }

    @PostMapping("/join")
    @ResponseBody
    public String join(@ModelAttribute("UserTblVO") UserTblVO vo) throws Exception {

        System.out.println(vo.getUserId());
        System.out.println(vo.getUserPw());
        System.out.println(vo.getName());
        System.out.println(vo.getEmail());

        int insertCount = userDAO.insertUser(vo);

        if (insertCount == 1) {
            return "OK";
        }
        else {
            return "FAIL";
        }
    }
    
    @GetMapping("/idinquiry")
    public String idinquiry() {
        return "idinquiry";
    }

    // @PostMapping("/idinquiry")
    // @ResponseBody
    // public UserTblVO idinquiry(@ModelAttribute("UserTblVO") UserTblVO vo) throws Exception {

    //     UserTblVO resultVO = userDAO.selectOneUserEmail(vo); // VO가 이메일을 가져왔다.
    //     System.out.println(resultVO);        
    //     return resultVO;
    // }

    @PostMapping("/idinquiry")
    @ResponseBody
    public String idinquiry(@ModelAttribute("UserTblVO") UserTblVO vo) throws Exception {

        UserTblVO resultVO = userDAO.selectOneUserByEmail(vo); // VO가 이메일을 가져왔다.
        System.out.println(resultVO);

        if (resultVO != null) {
            // resultVO에 있는 userId를 변수에 저장
            String userId = resultVO.getUserId();
    
            // userId의 끝 세자리를 마스킹해서 변수에 저장
            String maskedUserId = userId.substring(0, userId.length() - 3) + "***";
            System.out.println(maskedUserId);        

            // 이건 강사님 코드
            // String id = "";
            // int len = 0;
            // len = resultVO.getUserId().length();
            // id = resultVO.getUserId().substring(0, len - 2);
            // id += "**";
            // return id;
    
            return maskedUserId;
        }
        else {
            return "$FAIL"; // 아이디가 fail인 유저가 있을 수 있으므로 특수문자를 추가한 것
        }
    }    

    @GetMapping("/pwinquiry")
    public String pwinquiry() {
        return "pwinquiry";
    }

    @PostMapping("/pwinquiry")
    @ResponseBody
    public String pwinquiry(@ModelAttribute("UserTblVO") UserTblVO vo) throws Exception {

        UserTblVO resultVO = userDAO.selectOneUserByUserId(vo); // VO가 아이디를 가져왔다.
        System.out.println(resultVO);

        String senderName = "miruyseong@gmail.com"; // 관리자의 이메일을 세팅
        String senderPasswd = "hkfugthkufcydqlu";   // 구글 계정의 앱 비밀번호 16자
        GmailSender gmailSender = null;
        
        if (resultVO == null) {
            return "$FAIL";
        }
        else {
            // 비밀번호를 메일로 전송한다.
            gmailSender = new GmailSender(senderName, senderPasswd);
            gmailSender.sendEmail(resultVO.getEmail(), "비밀번호 전송", "비밀번호: " + resultVO.getUserPw());
            // sendEmail의 파라미터(3개)
            // param 1. 받을 사람의 이메일 주소
            // param 2. 이메일의 제목
            // param 3. 이메일의 내용

            return "$OK";
        }
    }

    @GetMapping("/bstest")
    public String bstest() {
        return "bstest";
    }

    @GetMapping("/maptest")
    public String maptest() {
        return "maptest";
    }
}
