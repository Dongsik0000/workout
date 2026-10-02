package workout.auth.dao;

import jakarta.annotation.Resource;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Repository("authDAO")
public class AuthDAO {

    @Resource(name = "sqlSession-workout-postgre")
    private SqlSessionTemplate sqlSession;

    public static final String SQL_PATH = "workout.auth.dao.AuthDAO";

    public Map<String, Object> selectUserByUsername(String username) {
        return sqlSession.selectOne(SQL_PATH + ".selectUserByUsername", username);
    }

    public String selectPasswordHash(long userId) {
        return sqlSession.selectOne(SQL_PATH + ".selectPasswordHash", userId);
    }

    // param: userId, passwordHash
    public int updatePassword(Map<String, Object> param) {
        return sqlSession.update(SQL_PATH + ".updatePassword", param);
    }

    // param: username, passwordHash. 실행 후 param.id 에 생성된 키가 들어간다
    public int insertUser(Map<String, Object> param) {
        return sqlSession.insert(SQL_PATH + ".insertUser", param);
    }
}
