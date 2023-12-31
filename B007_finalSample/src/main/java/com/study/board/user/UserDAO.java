package com.study.board.user;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository // 이 클래스를 레파지토리로 쓰겠다고 알리는 어노테이션(데이터의 생성, 이용 등을 모두 관할)
public class UserDAO {
    
    @Autowired
    private SqlSessionTemplate sqlSessionTemplete;

    public UserTblVO selectOneUser(UserTblVO vo) throws Exception {
        return sqlSessionTemplete.selectOne("selectOneUser", vo);
    }

    // public UserTblVO selectOneUserById(UserTblVO vo) throws Exception {
    //     return sqlSessionTemplete.selectOne("selectOneUserById", vo);
    // }

    public int insertUser(UserTblVO vo) throws Exception {
        return sqlSessionTemplete.insert("insertUser", vo);
    }

    public UserTblVO selectOneUserByEmail(UserTblVO vo) throws Exception {
        return sqlSessionTemplete.selectOne("selectOneUserByEmail", vo);
    }

    public UserTblVO selectOneUserByUserId(UserTblVO vo) throws Exception {
        return sqlSessionTemplete.selectOne("selectOneUserByUserId", vo);
    }
}
